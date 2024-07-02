function getQueryParameter(name) {
  const urlParams = new URLSearchParams(window.location.search);
  return urlParams.get(name);
}

// Verifica si el parámetro de consulta 'login' está presente y tiene el valor 'success'
const loginStatus = getQueryParameter('login');
if (loginStatus === 'success') {
  const userIcon = document.getElementById('user-icon');
  if(userIcon){
    userIcon.src = '../img/index/usuarioLogeado.svg';
    userIcon.alt = 'Usuario logeado'; // Texto alternativo opcional
  }
}
