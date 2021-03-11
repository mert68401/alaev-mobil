const jwt = require("jsonwebtoken");
module.exports = function (req, res, next) {
  // use token from the header
  const token = req.header("Authorization");

  if (!token) {
    return res.status(401).json({ msg: "No token provided" });
  }
  try {
    console.log(token);
    const decoded = jwt.verify(token, process.env.JWT_SECRET_KEY);
    req.user = decoded;
    next();
  } catch (err) {
    console.log(err);
    res.status(401).json({ msg: "Invalid token" });
  }
};
