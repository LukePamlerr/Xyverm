<template>
  <div>
    <header style="display:flex; align-items:center; justify-content:space-between; gap:1rem;">
      <h1 style="margin:0">Wyvem</h1>
      <nav>
        <router-link to="/">Dashboard</router-link>
        |
        <router-link to="/migration">Migration</router-link>
        |
        <router-link to="/sso">SSO</router-link>
      </nav>
    </header>
    <main style="margin-top:1rem">
      <router-view />
    </main>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
body { font-family: system-ui, Arial, sans-serif; margin: 2rem; }
nav a { margin: 0 0.5rem }
</style>
<template>
  <div>
    <header style="display:flex; align-items:center; justify-content:space-between; gap:1rem;">
      <h1 style="margin:0">Wyvem</h1>
      <nav>
        <router-link to="/">Dashboard</router-link>
        |
        <router-link to="/migration">Migration</router-link>
        |
        <router-link to="/sso">SSO</router-link>
      </nav>
    </header>
    <main style="margin-top:1rem">
      <router-view />
    </main>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
body { font-family: system-ui, Arial, sans-serif; margin: 2rem; }
nav a { margin: 0 0.5rem }
</style>
