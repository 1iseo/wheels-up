import vine from '@vinejs/vine'

export const signUpValidator = vine.compile(vine.object({
    email: vine.string().email(),
    password: vine.string().minLength(8),
    full_name: vine.string().trim().maxLength(255),
    username: vine.string().trim().maxLength(50).minLength(4),
    role: vine.enum(['penyewa', 'pemilik', 'admin']),
}))

export const loginValidator = vine.compile(vine.object({
    email: vine.string().email().optional(),
    username: vine.string().trim().maxLength(50).minLength(4).optional(),
    password: vine.string().minLength(8),
}))