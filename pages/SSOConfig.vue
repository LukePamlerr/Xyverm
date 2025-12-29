<template>
  <div>
    <h2>SSO Providers</h2>

    <div style="display:flex; gap:1rem">
      <div style="flex:1">
        <h3>Providers</h3>
        <ul>
          <li v-for="p in providers" :key="p.id">
            <strong>{{ p.name }}</strong> — {{ p.type }}
            <button @click="edit(p)">Edit</button>
            <button @click="remove(p)" style="color:red">Delete</button>
          </li>
        </ul>
      </div>

      <div style="flex:2">
        <h3>{{ editing ? 'Edit' : 'New' }} Provider</h3>
        <form @submit.prevent="save">
          <div>
            <label>Provider Name</label>
            <input v-model="provider.name" />
          </div>
          <div>
            <label>Type</label>
            <select v-model="provider.type">
              <option value="oidc">OIDC</option>
              <option value="saml">SAML</option>
              <option value="ldap">LDAP</option>
            </select>
          </div>
          <div v-if="provider.type === 'oidc'">
            <label>Client ID</label>
            <input v-model="provider.client_id" />
            <label>Client Secret</label>
            <input v-model="provider.client_secret" type="password" />
            <label>Discovery URL</label>
            <input v-model="provider.discovery" />
          </div>
          <button type="submit">Save</button>
          <button type="button" @click="reset">Cancel</button>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import { listProviders, createProvider, updateProvider, deleteProvider } from '../services/sso'

export default {
  data() {
    return {
      providers: [],
      provider: { name: '', type: 'oidc' },
      editing: false
    }
  },
  async mounted() {
    await this.reload()
  },
  methods: {
    async reload() {
      const res = await listProviders()
      this.providers = res.data.data || []
    },
    edit(p) {
      this.editing = true
      this.provider = Object.assign({}, p)
    },
    reset() {
      this.editing = false
      this.provider = { name: '', type: 'oidc' }
    },
    async save() {
      try {
        if (this.editing && this.provider.id) {
          await updateProvider(this.provider.id, this.provider)
        } else {
          await createProvider(this.provider)
        }
        await this.reload()
        this.reset()
        alert('Saved')
      } catch (e) {
        alert('Error: ' + e.message)
      }
    },
    async remove(p) {
      if (!confirm('Delete provider "' + p.name + '"?')) return
      await deleteProvider(p.id)
      await this.reload()
    }
  }
}
</script>

<style scoped>
form > div { margin-bottom: 0.6rem }
input, select { width: 100%; padding: 0.4rem }
</style>
<template>
  <div>
    <h2>SSO Providers</h2>

    <div style="display:flex; gap:1rem">
      <div style="flex:1">
        <h3>Providers</h3>
        <ul>
          <li v-for="p in providers" :key="p.id">
            <strong>{{ p.name }}</strong> — {{ p.type }}
            <button @click="edit(p)">Edit</button>
            <button @click="remove(p)" style="color:red">Delete</button>
          </li>
        </ul>
      </div>

      <div style="flex:2">
        <h3>{{ editing ? 'Edit' : 'New' }} Provider</h3>
        <form @submit.prevent="save">
          <div>
            <label>Provider Name</label>
            <input v-model="provider.name" />
          </div>
          <div>
            <label>Type</label>
            <select v-model="provider.type">
              <option value="oidc">OIDC</option>
              <option value="saml">SAML</option>
              <option value="ldap">LDAP</option>
            </select>
          </div>
          <div v-if="provider.type === 'oidc'">
            <label>Client ID</label>
            <input v-model="provider.client_id" />
            <label>Client Secret</label>
            <input v-model="provider.client_secret" type="password" />
            <label>Discovery URL</label>
            <input v-model="provider.discovery" />
          </div>
          <button type="submit">Save</button>
          <button type="button" @click="reset">Cancel</button>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import { listProviders, createProvider, updateProvider, deleteProvider } from '../services/sso'

export default {
  data() {
    return {
      providers: [],
      provider: { name: '', type: 'oidc' },
      editing: false
    }
  },
  async mounted() {
    await this.reload()
  },
  methods: {
    async reload() {
      const res = await listProviders()
      this.providers = res.data.data || []
    },
    edit(p) {
      this.editing = true
      this.provider = Object.assign({}, p)
    },
    reset() {
      this.editing = false
      this.provider = { name: '', type: 'oidc' }
    },
    async save() {
      try {
        if (this.editing && this.provider.id) {
          await updateProvider(this.provider.id, this.provider)
        } else {
          await createProvider(this.provider)
        }
        await this.reload()
        this.reset()
        alert('Saved')
      } catch (e) {
        alert('Error: ' + e.message)
      }
    },
    async remove(p) {
      if (!confirm('Delete provider "' + p.name + '"?')) return
      await deleteProvider(p.id)
      await this.reload()
    }
  }
}
</script>

<style scoped>
form > div { margin-bottom: 0.6rem }
input, select { width: 100%; padding: 0.4rem }
</style>
