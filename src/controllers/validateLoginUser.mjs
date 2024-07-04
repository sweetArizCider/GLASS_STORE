import { logearUsuario } from "../models/loginUser.mjs";
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const login = async (req, res) => {
  const { correo, contraseña } = req.body;
  try {
    const usuario = await logearUsuario(correo, contraseña);
    if (usuario) {
      res.redirect('/?login=success');
    } else {
      console.error('Credenciales incorrectas');
      res.status(401).send('Credenciales incorrectas');
    }
  } catch (error) {
    console.error('Error en login: ', error);
    res.status(500).send('Error en el servidor');
  }
};
