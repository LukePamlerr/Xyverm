import { createRouter, createWebHistory } from 'vue-router'
import Dashboard from '../pages/Dashboard.vue'
import Migration from '../pages/Migration.vue'
import SSOConfig from '../pages/SSOConfig.vue'

const routes = [
  { path: '/', name: 'Dashboard', component: Dashboard },
  { path: '/migration', name: 'Migration', component: Migration },
  { path: '/sso', name: 'SSO', component: SSOConfig }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
import { createRouter, createWebHistory } from 'vue-router'
import Dashboard from '../pages/Dashboard.vue'
import Migration from '../pages/Migration.vue'
import SSOConfig from '../pages/SSOConfig.vue'

const routes = [
  { path: '/', name: 'Dashboard', component: Dashboard },
  { path: '/migration', name: 'Migration', component: Migration }
  ,{ path: '/sso', name: 'SSO', component: SSOConfig }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
