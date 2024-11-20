import { configApp } from '@adonisjs/eslint-config'
import pluginSecurity from 'eslint-plugin-security'

export default configApp(pluginSecurity.configs.recommended);
