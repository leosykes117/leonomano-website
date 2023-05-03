import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'

// import assets
import './assets/scss/main.scss'

// import plugins
import '@/plugins/bootstrap'

const app = createApp(App)

app.use(createPinia())
app.use(router)

app.mount('#app')
