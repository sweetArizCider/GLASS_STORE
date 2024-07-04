export const isAuthenticated = (req, res, next) => {
    if (req.session.user && req.session.user.id) {
      return next();
    } else {
      res.redirect('/login');
    }
  };
  