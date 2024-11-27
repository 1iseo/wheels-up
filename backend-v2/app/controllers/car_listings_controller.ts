import { HttpContext } from '@adonisjs/core/http'
import CarListing from '#models/car_listing'
import { listingUpdateValidator, listingValidator } from '#validators/car_listing'
import { inject } from '@adonisjs/core'
import { CarListingService } from '#services/car_listing_service'

export default class CarListingsController {
  public async showAllListings({ request, response, auth }: HttpContext) {
    await auth.authenticate()
    const page = request.input('page', 1)
    const listings = await CarListing.query().paginate(page, 10)
    return response.json(listings)
  }

  public async showListing({ request, response, auth }: HttpContext) {
    await auth.authenticate()
    const id = request.param('id')
    const listing = await CarListing.findOrFail(id)
    return response.json(listing)
  }

  public async createListing({ request, response, auth }: HttpContext) {
    const user = await auth.authenticate()
    console.log(request.all())
    let payload = await listingValidator.validate(request.all())
    let payloadWithUser = {
      ...payload,
      posterId: user.id,
      thumbnail: Buffer.from(payload.thumbnail, 'base64')
    }
    console.log("HERE")
    const listing = await CarListing.create(payloadWithUser)
    console.log(listing)
    return response.json(listing)
  }

  public async updateListing({ request, response, auth }: HttpContext) {
    const user = await auth.authenticate()
    const id = request.param('id')
    const listing = await CarListing.findOrFail(id)

    if (listing.posterId !== user.id && user.role !== 'admin') {
      return response.status(401).json({ message: 'Unauthorized' })
    }

    let payload = await listingUpdateValidator.validate(request.all())

    listing.merge(payload)
    await listing.save()
    return response.json(listing)
  }

  public async deleteListing({ request, response, auth }: HttpContext) {
    const user = await auth.authenticate()
    const id = request.param('id')
    const listing = await CarListing.findOrFail(id)

    if (listing.posterId !== user.id && user.role !== 'admin') {
      return response.status(401).json({ message: 'Unauthorized' })
    }

    await listing.delete()
    return response.status(200).json({ message: 'Listing deleted successfully' })
  }

  @inject()
  public async searchListings(
    { request, response, auth }: HttpContext,
    carListingService: CarListingService
  ) {
    console.log('HII', carListingService)
    await auth.authenticate()
    const query = request.input('query')
    const results = await carListingService.search(query)
    return response.json(results)
  }
}
