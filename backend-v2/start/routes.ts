/*
|--------------------------------------------------------------------------
| Routes file
|--------------------------------------------------------------------------
|
| The routes file is used for defining the HTTP routes.
|
*/

import router from '@adonisjs/core/services/router'
const AuthController = () => import('#controllers/auth_controller')
const CarListingsController = () => import('#controllers/car_listings_controller')

router.get('/', async () => {
  return {
    hello: 'world',
  }
})

router.post('/auth/login', [AuthController, 'login'])
router.post('/auth/register', [AuthController, 'register'])
router.get('/listings', [CarListingsController, 'showAllListings'])
router.get('/listings/search', [CarListingsController, 'searchListings'])
router.post('/listings', [CarListingsController, 'createListing'])
router.get('/listings/:id', [CarListingsController, 'showListing'])
router.put('/listings/:id', [CarListingsController, 'updateListing'])
router.delete('/listings/:id', [CarListingsController, 'deleteListing'])
