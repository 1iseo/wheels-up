import { Hono, Context } from 'hono'
import { bearerAuth } from 'hono/bearer-auth'
import { drizzle, DrizzleD1Database } from 'drizzle-orm/d1';
import { insertSessionSchema, insertUserSchema, loginSchema, registerSchema, selectUserSchema, sessions, users } from './schema';
import { z } from 'zod';
import { eq, or } from 'drizzle-orm';
import { v4 as uuidv4 } from 'uuid';
import { Future, Result } from '@swan-io/boxed';
import { HTTPException } from 'hono/http-exception';
import { getConnInfo } from 'hono/cloudflare-workers';

interface LoginRequest {
  username_or_email: string;
  password: string;
  ip?: string
}

type RegistrationRequest = z.infer<typeof registerSchema>

type UserSchema = z.infer<typeof selectUserSchema>

type NewSessionRequest = z.infer<typeof insertSessionSchema>

type Bindings = {
  DB: D1Database;
}

const app = new Hono<{ Bindings: Bindings }>()

function getDbFromContext(ctx: Context<{ Bindings: Bindings }>) {
  return drizzle(ctx.env.DB);
}

class ValidationError extends Error {
  readonly type = "validation-error"
}

class DatabaseError extends Error {
  readonly type = "database-error"
}

class NoMatchingRecordError extends Error {
  readonly type = "no-matching-record-error"
}

type ApplicationError = ValidationError | DatabaseError | NoMatchingRecordError | Error

function processRegistrationRequest(db: DrizzleD1Database, req: RegistrationRequest): Future<Result<void, ApplicationError>> {
  return Future.fromPromise(db.insert(users).values(req))
    .flatMapOk(() => Future.value(Result.Ok(undefined)))
    .flatMapError((e) => Future.value(Result.Error(new DatabaseError("error ketika memproses request registrasi user baru", { cause: e }))))
}

function processLoginRequest(db: DrizzleD1Database, req: LoginRequest): Future<Result<string, ApplicationError>> {
  let query = db.select().from(users).where(or(eq(users.username, req.username_or_email), eq(users.email, req.username_or_email)))
  let userFuture = Future.fromPromise<UserSchema[], ApplicationError>(query)
  let validation: Future<Result<UserSchema[], ApplicationError>> = userFuture.map<Result<UserSchema[], ApplicationError>>(val => {
    return val.flatMap(user => {
      if (user.length == 0) {
        return Result.Error(new NoMatchingRecordError("user tidak ditemukan"))
      }

      if (user[0].password != req.password) {
        return Result.Error(new ValidationError("password tidak sesuai"))
      }

      return Result.Ok(user)
    })
  })

  let newUserSession = validation.flatMap<Result<string, ApplicationError>>(val => {
    if (val.isError()) {
      return Future.value(Result.Error(val.error))
    }

    let user = val.value
    let sessionRequest: NewSessionRequest = {
      token: uuidv4(),
      userId: user[0].id,
      ip: req.ip || "",
    }

    let sessionFuture = Future.fromPromise(db.insert(sessions).values(sessionRequest))
    let createdSessionToken = sessionFuture
      .mapOk(() => sessionRequest.token)
      .mapError<string, unknown, ApplicationError>(e => new DatabaseError("error ketika memproses request login", { cause: e }))


    return createdSessionToken
  })


  return newUserSession
}

let authMiddleware = bearerAuth({
  verifyToken: async (token, c) => {
    let db = getDbFromContext(c)
    let session = await db.select().from(sessions).where(eq(sessions.token, token))
    if (session.length == 0) {
      return false;
    }

    return true
  }
})

app.get('/', (c) => {
  return c.text('Hello Hono!')
})

app.get('/protected', authMiddleware, (c) => {

  return c.text('Hello Hono!')
})

app.post('/auth/register', async (c) => {
  const body = await c.req.parseBody()
  const validated = registerSchema.safeParse(body)

  if (validated.success) {
    let request = await processRegistrationRequest(getDbFromContext(c), validated.data);
    if (request.isOk()) {
      return c.json({
        status: "ok"
      })
    }

    let resp = Response.json({
      status: "error",
      message: "internal error",
      context: request.error.message
    })

    throw new HTTPException(422, { res: resp, cause: request.error })
  }

  let resp = Response.json({
    status: "error",
    message: "invalid form data",
    error: validated.error
  })
  throw new HTTPException(400, { res: resp })
})

app.post('/auth/login', async (c) => {
  const body = await c.req.parseBody()
  const validated = loginSchema.safeParse(body)

  if (validated.success) {
    const ip = getConnInfo(c).remote.address || ""
    let data = validated.data as LoginRequest
    data.ip = ip

    let request = await processLoginRequest(getDbFromContext(c), data)
    if (request.isOk()) {
      let token = request.get()
      c.res.headers.append("Authorization", `Bearer ${token}`)
      c.status(200)

      return c.body('ok')
    }

    let resp = Response.json({
      status: "error",
      message: "internal error",
      context: request.error.message
    })

    throw new HTTPException(422, { res: resp, cause: request.error })
  }

  let resp = Response.json({
    status: "error",
    message: "invalid form data",
    error: validated.error
  })
  throw new HTTPException(400, { res: resp })
})

export default app
