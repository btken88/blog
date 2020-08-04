fetch('your-backend-location', {
  method: 'POST',
  body: JSON.stringify({ username, password })
}).then(response => response.json())
  .then(({ token }) => localStorage.setItem('token', token))


