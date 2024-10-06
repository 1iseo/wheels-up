import { sql } from 'drizzle-orm';
import { text, integer, sqliteTable } from "drizzle-orm/sqlite-core";
import { createInsertSchema, createSelectSchema } from 'drizzle-zod';
import { z } from 'zod';

export const users = sqliteTable('user', {
    id: integer('id').primaryKey({ autoIncrement: true }),
    createdAt: integer('created_at').default(sql`(unixepoch())`).notNull(),
    name: text('name').notNull(),
    username: text('username').notNull().unique(),
    email: text('email').notNull().unique(),
    password: text('password').notNull(),
    role: text('role', { enum: ["admin", "penyewa", "penyedia"] }).notNull(),
    lastLoggedIn: integer('last_logged_in'),
})

export const sessions = sqliteTable('session', {
    id: integer('id').primaryKey({ autoIncrement: true }),
    createdAt: integer('created_at').default(sql`(unixepoch())`).notNull(),
    userId: integer('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
    token: text('token').notNull().unique(),
    ip: text('ip').notNull(),
})

export const insertUserSchema = createInsertSchema(users, {
    email: (schema) => schema.email.email(),
    username: (schema) => schema.username.min(4).max(32).regex(/^[a-zA-Z0-9]+$/),
    password: (schema) => schema.password.min(8).max(64)
})

export const insertSessionSchema = createInsertSchema(sessions)

export const registerSchema = insertUserSchema.pick({ email: true, name: true, username: true, password: true, role: true })

export const selectUserSchema = createSelectSchema(users)

export const loginSchema = insertUserSchema.pick({"password": true}).extend({
    username_or_email: z.string().min(4)
})
