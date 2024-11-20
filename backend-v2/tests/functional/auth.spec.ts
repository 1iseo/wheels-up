import { test } from '@japa/runner'
import { faker } from '@faker-js/faker'
import { UserFactory } from '#database/factories/user_factory'
import User from '#models/user'

test.group('Auth', (group) => {
  // Clean up database after each test
  group.each.setup(async () => {
    await User.query().delete()
  })

  test('register creates a new user and returns token', async ({ client, assert }) => {
    const userData = {
      email: faker.internet.email(),
      password: 'testing-123',
      username: faker.internet.username(),
      full_name: faker.person.fullName(),
      role: 'penyewa',
    }

    const response = await client.post('/auth/register').json(userData)

    response.assertStatus(200)
    assert.properties(response.body(), ['token'])
    assert.isString(response.body().token)
  })

  test('register fails with invalid data', async ({ client, assert }) => {
    const response = await client.post('/auth/register').json({
      email: 'invalid-email',
      password: '123', // Too short
      username: '', // Required
      full_name: faker.person.fullName(),
      role: 'invalid-role',
    })

    response.assertStatus(422)
    assert.properties(response.body(), ['errors'])
  })

  test('register fails with duplicate email', async ({ client, assert }) => {
    const email = faker.internet.email()
    await UserFactory.merge({
      email,
      username: faker.internet.username(),
      role: 'pemilik',
    }).create()

    const response = await client.post('/auth/register').json({
      email,
      password: 'Password123!',
      username: faker.internet.username(),
      full_name: faker.person.fullName(),
      role: 'pemilik',
    })

    response.assertStatus(422)
    assert.properties(response.body(), ['errors'])
  })

  test('register fails with duplicate username', async ({ client, assert }) => {
    const username = faker.internet.username()
    await UserFactory.merge({
      email: faker.internet.email(),
      username,
      role: 'penyewa',
    }).create()

    const response = await client.post('/auth/register').json({
      email: faker.internet.email(),
      password: 'Password123!',
      username,
      full_name: faker.person.fullName(),
      role: 'penyewa',
    })

    response.assertStatus(422)
    assert.properties(response.body(), ['errors'])
  })

  test('login returns token with valid email credentials', async ({ client, assert }) => {
    const user = await UserFactory.merge({
      role: 'penyewa',
      password: 'testing-123',
    }).create()

    const response = await client.post('/auth/login').json({
      email: user.email,
      password: 'testing-123',
    })

    response.assertStatus(200)
    assert.properties(response.body(), ['token'])
    assert.isString(response.body().token)
  })

  test('login returns token with valid username credentials', async ({ client, assert }) => {
    const user = await UserFactory.merge({
      role: 'penyewa',
      password: 'testing-123',
    }).create()

    const response = await client.post('/auth/login').json({
      email: user.email,
      password: 'testing-123',
    })

    response.assertStatus(200)
    assert.properties(response.body(), ['token'])
    assert.isString(response.body().token)
  })

  test('login fails with invalid credentials', async ({ client, assert }) => {
    const user = await UserFactory.create()

    const response = await client.post('/auth/login').accept('json').json({
      email: user.email,
      password: 'wrong-password',
    })

    response.assertStatus(400)
    assert.properties(response.body(), ['errors'])
  })

  test('login fails with missing fields', async ({ client, assert }) => {
    const response = await client.post('/auth/login').json({
      password: 'Password123!',
    })

    response.assertStatus(400)
    assert.properties(response.body(), ['errors'])
  })

  test('login fails with non-existent user', async ({ client, assert }) => {
    const response = await client.post('/auth/login').json({
      email: 'nonexistent@example.com',
      password: 'Password123!',
    })

    response.assertStatus(400)
    assert.properties(response.body(), ['errors'])
  })
})
