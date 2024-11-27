import { test } from '@japa/runner'
import { CarListingFactory } from '#database/factories/car_listing_factory'
import { UserFactory } from '#database/factories/user_factory'
import CarListing from '#models/car_listing'
import { assert } from '@japa/assert'

test.group('Car Listings Controller', (group) => {
  group.each.setup(async () => {
    await CarListing.query().delete()
  })

  test('show all listings - authenticated user can view paginated listings', async ({ client }) => {
    const user = await UserFactory.create()
    await CarListingFactory.merge({ posterId: user.id }).createMany(15)

    const response = await client.get('/listings').loginAs(user)

    response.assertStatus(200)
    response.assertBodyContains({ meta: { total: 15, perPage: 10 } })
  })

  test('show listing - can view specific listing details', async ({ client }) => {
    const user = await UserFactory.create()
    const listing = await CarListingFactory.merge({ posterId: user.id }).create()

    const response = await client.get(`/listings/${listing.id}`).loginAs(user)

    response.assertStatus(200)
    response.assertBodyContains({ id: listing.id })
  })

  test('create listing - authenticated user can create a listing', async ({ client }) => {
    const user = await UserFactory.create()
    const listingData = {
      name: 'Test Car',
      description: 'A great test car',
      price: 500000,
      thumbnail: Buffer.from('test image data').toString('base64'),
      features: ['GPS', 'Leather Seats'],
      requirements: ['Valid License', 'Insurance'],
      location: 'Test City',
    }

    const response = await client.post('/listings').json(listingData).loginAs(user)

    response.assertStatus(200)
    response.assertBodyContains({
      name: listingData.name,
      posterId: user.id,
    })

    console.log(response.body())
  })

  test('create listing - validates required fields', async ({ client }) => {
    const user = await UserFactory.create()
    const invalidData = {
      title: 'Test Car',
      // missing required fields
    }

    const response = await client.post('/listings').json(invalidData).loginAs(user)

    response.assertStatus(422)
  })

  test('update listing - owner can update their listing', async ({ client }) => {
    const user = await UserFactory.create()
    const listing = await CarListingFactory.merge({ posterId: user.id }).create()
    const updateData = {
      name: 'Updated Title',
      price: 600000,
    }

    const response = await client.put(`/listings/${listing.id}`).json(updateData).loginAs(user)

    response.assertStatus(200)
    response.assertBodyContains({
      name: updateData.name,
      price: updateData.price,
    })
  })

  test('update listing - non-owner cannot update listing', async ({ client }) => {
    const owner = await UserFactory.create()
    const nonOwner = await UserFactory.create()
    const listing = await CarListingFactory.merge({ posterId: owner.id }).create()

    const response = await client
      .put(`/listings/${listing.id}`)
      .json({ title: 'Unauthorized Update' })
      .loginAs(nonOwner)

    response.assertStatus(401)
  })

  test('delete listing - owner can delete their listing', async ({ client }) => {
    const user = await UserFactory.create()
    const listing = await CarListingFactory.merge({ posterId: user.id }).create()

    const response = await client.delete(`/listings/${listing.id}`).loginAs(user)

    response.assertStatus(200)
    response.assertBodyContains({ message: 'Listing deleted successfully' })
  })

  test('delete listing - non-owner cannot delete listing', async ({ client }) => {
    const owner = await UserFactory.create()
    const nonOwner = await UserFactory.create()
    const listing = await CarListingFactory.merge({ posterId: owner.id }).create()

    const response = await client.delete(`/listings/${listing.id}`).loginAs(nonOwner)

    response.assertStatus(401)
  })

  test('search listings - can search listings with query', async ({ client, assert }) => {
    const user = await UserFactory.create()

    await CarListingFactory.merge({ posterId: user.id }).createMany(5)
    await CarListingFactory.merge({ posterId: user.id, description: 'test car' }).create()

    const response = await client.get('/listings/search').qs({ query: 'test' }).loginAs(user)

    assert.isTrue(response.body().length > 0)
    response.assertStatus(200)
    response.assertBodyContains([]) // Assuming empty result for test query
  })

  test('unauthenticated access is denied', async ({ client }) => {
    const response = await client.get('/listings')
    response.assertStatus(401)
  })
})
