import factory from '@adonisjs/lucid/factories'
import User from '#models/user'

export const UserFactory = factory
  .define(User, async ({ faker }) => {
    return {
      fullName: faker.person.fullName(),
      username: faker.internet.username(),
      password: faker.internet.password(),
      email: faker.internet.email(),
      role: 'penyewa' as 'admin' | 'penyewa' | 'pemilik',
    }
  })
  .build()
