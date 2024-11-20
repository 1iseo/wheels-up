import type { HttpContext } from '@adonisjs/core/http'
import User from '#models/user'
import { loginValidator, signUpValidator } from '#validators/auth'
import { errors } from '@adonisjs/auth'

export default class AuthController {
    async login(context: HttpContext) {
        const request = context.request
        const body = request.body()

        const payload = await loginValidator.validate(body)

        let uid = ''
        if (payload.email) {
            uid = body.email
        } else if (payload.username) {
            uid = body.username
        } else {
            throw new errors.E_INVALID_CREDENTIALS("Invalid user credentials")
        }

        const password = body.password
        const user = await User.verifyCredentials(uid, password)
        const token = await User.accessTokens.create(user)
        return token
    }

    async register(context: HttpContext) {
        const request = context.request
        const payload = await signUpValidator.validate(request.all())

        // check if username and email is unique
        const usernameExists = await User.findBy('username', payload.username)
        const emailExists = await User.findBy('email', payload.email)
        if (usernameExists || emailExists) {
            return context.response.status(422).json({
                errors: {
                    username: 'Username already exists',
                    email: 'Email already exists',
                },
            })
        }

        const user = await User.create(payload)
        const token = await User.accessTokens.create(user)
        return token
    }
}