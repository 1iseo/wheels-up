import factory from '@adonisjs/lucid/factories'
import CarListing from '#models/car_listing'

export const CarListingFactory = factory
  .define(CarListing, async ({ faker }) => {
    return {
      name: faker.vehicle.model(),
      description: faker.lorem.paragraph(),
      features: faker.lorem.words(5).split(' '),
      requirements: faker.lorem.words(5).split(' '),
      price: faker.number.int({ min: 100000, max: 1000000 }),
      thumbnail: faker.image.url(),
      status: 'active' as 'active' | 'rented' | 'hidden',
      location: faker.location.city()
    }
  })
  .build()