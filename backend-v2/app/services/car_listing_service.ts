import CarListing from "#models/car_listing";

export class CarListingService {
    public async search(q: string) {
        const processedQuery = q.split(' ').map(word => `${word}:*`).join(' & ');
        return CarListing.query()
            .whereRaw(`search_vector @@ to_tsquery('indonesian', ?)`, [processedQuery])
            .orderByRaw(`ts_rank(search_vector, to_tsquery('indonesian', ?)) DESC`, [processedQuery])
            .preload('poster', (query) => query.select('id', 'full_name', 'email'));
    }
}