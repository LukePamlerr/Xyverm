<template>
  <div>
    <h2>Migration Tool</h2>
    <form @submit.prevent="submit">
      <div>
        <label>Source Pterodactyl API URL</label>
        <input v-model="api_url" placeholder="https://ptero.example/api/" />
      </div>
      <div>
        <label>API Key</label>
        <input v-model="api_key" placeholder="application:xxxxx" />
      </div>
      <button type="submit">Start Migration</button>
    </form>

    <div v-if="result">
      <h3>Result</h3>
      <pre>{{ result }}</pre>
    </div>
  </div>
</template>

<script>
import api from '../services/api'
export default {
  data() {
    return { api_url: '', api_key: '', result: null }
  },
  methods: {
    async submit() {
      try {
        const res = await api.post('/pterodactyl/migrate', { api_url: this.api_url, api_key: this.api_key })
        this.result = res.data
      } catch (e) {
        this.result = { error: e.message }
      }
    }
  }
}
</script>

<style scoped>
form > div { margin-bottom: 0.5rem }
input { width: 100%; padding: 0.4rem }
</style>
<template>
  <div>
    <h2>Migration Tool</h2>
    <form @submit.prevent="submit">
      <div>
        <label>Source Pterodactyl API URL</label>
        <input v-model="api_url" placeholder="https://ptero.example/api/" />
      </div>
      <div>
        <label>API Key</label>
        <input v-model="api_key" placeholder="application:xxxxx" />
      </div>
      <button type="submit">Start Migration</button>
    </form>

    <div v-if="result">
      <h3>Result</h3>
      <pre>{{ result }}</pre>
    </div>
  </div>
</template>

<script>
import api from '../services/api'
export default {
  data() {
    return { api_url: '', api_key: '', result: null }
  },
  methods: {
    async submit() {
      try {
        const res = await api.post('/pterodactyl/migrate', { api_url: this.api_url, api_key: this.api_key })
        this.result = res.data
      } catch (e) {
        this.result = { error: e.message }
      }
    }
  }
}
</script>

<style scoped>
form > div { margin-bottom: 0.5rem }
input { width: 100%; padding: 0.4rem }
</style>
