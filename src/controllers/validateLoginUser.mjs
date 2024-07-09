import { logearUsuario } from "../models/loginUser.mjs";

// funcion para logear un usuario
export const login = async (req, res) => {
  // declaro una lista con contraseña y correo que vendran del submit 
  const { correo, contraseña } = req.body;

  try{
    // declaro usuario, y es igual al resultado de la funcion logearUsuario, recordando que es un booleano
    const usuario = await logearUsuario(correo, contraseña);
    if(usuario){
      res.status(201).send('Usuario logeado'); // si es true logeado con exito
    } else{
    console.error('Credenciales error'); // si es false no se logea
    res.status(500).send('Error')
    }
  } catch(error) {
    console.error('Error en login: ', error);
    res.status(500).send('Error en el server')
  }
}