import vine from '@vinejs/vine'

export const listingValidator = vine.compile(vine.object({
  name: vine.string().maxLength(255),
  description: vine.string().maxLength(1000),
  price: vine.number().range([0, 2_000_000_000]),
  thumbnail: vine.string().url(),
  features: vine.array(vine.string().maxLength(255)),
  requirements: vine.array(vine.string().maxLength(255)),
  location: vine.string().maxLength(255),
}))

export const listingUpdateValidator = vine.compile(vine.object({
  name: vine.string().maxLength(255).optional(),
  description: vine.string().maxLength(1000).optional(),
  price: vine.number().range([0, 2_000_000_000]).optional(),
  thumbnail: vine.string().url().optional(),
  features: vine.array(vine.string().maxLength(255)).optional(),
  requirements: vine.array(vine.string().maxLength(255)).optional(),
  location: vine.string().maxLength(255).optional(),
}))
