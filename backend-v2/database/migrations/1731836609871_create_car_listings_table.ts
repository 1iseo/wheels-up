import { BaseSchema } from '@adonisjs/lucid/schema'

export default class extends BaseSchema {
  protected tableName = 'car_listings'

  async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.increments('id')

      table.string('name').notNullable()
      table.text('description').notNullable()
      table.specificType('features', 'text[]').notNullable()
      table.specificType('requirements', 'text[]').notNullable()
      table.integer('price').notNullable()
      table.string('thumbnail').notNullable()
      table.enum('status', ['active', 'rented', 'hidden']).defaultTo('active').notNullable()
      table.integer('poster_id').unsigned().references('id').inTable('users').notNullable()

      table.string('location').notNullable()
      table.specificType('search_vector', 'tsvector').nullable()

      table.timestamp('created_at').notNullable()
      table.timestamp('updated_at').nullable()
    })

    console.log(this.schema.toQuery())

    this.schema.raw(`
      CREATE FUNCTION car_listings_search_vector_update() RETURNS trigger AS $$
      BEGIN
        NEW.search_vector := 
          to_tsvector('indonesian',
            coalesce(NEW.name, '') || ' ' ||
            coalesce(NEW.description, '') || ' ' ||
            coalesce(array_to_string(NEW.features, ' '), '') || ' ' ||
            coalesce(array_to_string(NEW.requirements, ' '), '')
          );
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
  `)

    this.schema.raw(`
      CREATE TRIGGER car_listings_search_vector_trigger
      BEFORE INSERT OR UPDATE ON car_listings
      FOR EACH ROW
      EXECUTE FUNCTION car_listings_search_vector_update();
    `)

    this.schema.raw(`
      CREATE INDEX car_listings_search_idx ON car_listings USING GIN (search_vector);
    `)
  }

  async down() {
    await this.schema.raw(`
      DROP TRIGGER IF EXISTS car_listings_search_vector_trigger ON car_listings;
      DROP FUNCTION IF EXISTS car_listings_search_vector_update();
    `)

    this.schema.dropTable(this.tableName)
  }
}
