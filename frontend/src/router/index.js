import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/', name: 'home', component: () => import('../views/HomeView.vue') },
  { path: '/inscription', name: 'inscription', component: () => import('../views/RegistrationView.vue') },
  { path: '/consentement', name: 'consentement', component: () => import('../views/ConsentView.vue') },
  { path: '/formation', name: 'formation', component: () => import('../views/TrainingView.vue') },
  { path: '/formation/:id', name: 'module-detail', component: () => import('../views/ModuleDetailView.vue') },
  { path: '/certificat', name: 'certificat', component: () => import('../views/CertificateView.vue') },
  { path: '/espace-reporter', name: 'reporter', component: () => import('../views/ReporterView.vue') },
  { path: '/terrain', name: 'terrain', component: () => import('../views/FieldWorkView.vue') },
  { path: '/ponabana', name: 'ponabana', component: () => import('../views/PonabanaView.vue') },
  { path: '/dashboard', name: 'dashboard', component: () => import('../views/DashboardView.vue') },
  { path: '/admin', name: 'admin', component: () => import('../views/AdminView.vue') },
  { path: '/:pathMatch(.*)*', redirect: '/' }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  }
})

export default router
