import { DateTime } from 'luxon'
import { BaseModel, column, belongsTo } from '@adonisjs/lucid/orm'
import User from '#models/user'
import type { BelongsTo } from '@adonisjs/lucid/types/relations'

export default class CarListing extends BaseModel {
  @column({ isPrimary: true })
  declare id: number

  @column()
  declare name: string

  @column()
  declare description: string

  @column()
  declare features: string[]

  @column()
  declare requirements: string[]

  @column()
  declare price: number

  @column()
  declare thumbnail: string

  @column()
  declare location: string

  @column()
  declare status: 'active' | 'rented' | 'hidden'

  @column()
  declare posterId: number

  @belongsTo(() => User, { foreignKey: 'posterId' })
  declare poster: BelongsTo<typeof User>

  @column.dateTime({ autoCreate: true })
  declare createdAt: DateTime

  @column.dateTime({ autoCreate: true, autoUpdate: true })
  declare updatedAt: DateTime
}
