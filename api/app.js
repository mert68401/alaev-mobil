var request = require("request");
var httpPort = 2000;
const express = require("express");
const jwt = require("jsonwebtoken");
const bodyParser = require("body-parser");
const mongoClient = require("mongodb").MongoClient;
var url = "mongodb://localhost:27017/alaev";
// var url =
//   "mongodb+srv://devAccount:NzJECdw6qyT534CZ@cluster0.8khb6.mongodb.net/alaev?retryWrites=true&w=majority";
var database = null;
const nodemailer = require("nodemailer");
const fs = require("fs");
const util = require("util");
const activationMail = require("./email-templates/activation-mail");
const forgotPasswordMail = require("./email-templates/forgot-password");
const auth = require("./middleware/auth");

var path = require("path");

require("dotenv").config();
const log_file = fs.createWriteStream(__dirname + "/debug.log", { flags: "a" });
connectToMongo();
function connectToMongo() {
  mongoClient.connect(
    url,
    {
      useUnifiedTopology: true,
      useNewUrlParser: true,
    },
    function (err, client) {
      if (err) {
        console.log("Error on connection to MongoDB Server", err);
        setTimeout(() => {
          connectToMongo();
        }, 5000);
        return;
      }
      database = client.db("alaev");
      console.log("Connected to MongoDB Server!");
    }
  );
}

const app = express();
app.use(express.static("uploads"));

app.use(
  bodyParser.urlencoded({
    extended: true,
  })
);
app.use(bodyParser.json());
app.use(function (req, res, next) {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader(
    "Access-Control-Allow-Methods",
    "GET, POST, OPTIONS, PUT, PATCH, DELETE"
  );
  res.setHeader(
    "Access-Control-Allow-Headers",
    "X-Requested-With,Authorization,Content-Type,Nano-Token"
  );
  res.setHeader("Access-Control-Allow-Credentials", true);
  next();
});

var http = require("http").createServer(app);

app.get("/", function (req, res) {
  res.status(404).send("Not Found"); //write a response to the client
  res.end(); //end the response
});
var router = express.Router();

var multer = require("multer");
var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/photos");
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname)); //Appending extension
  },
});

var desti = multer({
  storage: storage,
  fileFilter: function (_req, file, cb) {
    checkFileType(file, cb);
  },
});
var file = desti.single("photo");

function checkFileType(file, cb) {
  // Allowed ext
  const filetypes = /jpeg|jpg|png|gif/;
  // Check ext
  const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
  // Check mime
  const mimetype = filetypes.test(file.mimetype);

  if (mimetype && extname) {
    return cb(null, true);
  } else {
    cb("Error: Images Only!");
  }
}

router.post("/makePost", auth, async (req, res) => {
  const userId = req.user._id;
  try {
    file(req, res, function (err) {
      const photo = req.file;
      if (photo) {
        const content = req.body.content;
        if (err instanceof multer.MulterError) {
          console.log(err);
          return res.send("A Multer error occurred when uploading1.");
        } else if (err) {
          console.log(err);
          return res.send("Lütfen resim dosyası yükleyiniz!");
        }
        database.collection("posts").insertOne({
          userId: userId,
          photo: "/photos/" + photo.filename,
          content: content,
          createdAt: new Date(),
        });

        return res.send("Resim yüklendi!");
      } else {
        return res.send("Resim alınamadı!");
      }
    });
  } catch (error) {
    return res.send(error.message);
  }
});

/*
// Register
*/
router.post("/register", function (req, res) {
  const body = req.body;
  console.log(body);
  var userObj;
  if (
    body.email.length > 0 &&
    body.fullName.length > 0 &&
    body.password.length > 0 &&
    body.role.length > 0 &&
    body.phone.length > 0 &&
    body.city.length > 0 &&
    body.graduateYear.length > 0
  ) {
    userObj = {
      _id: makeid(),
      email: {
        str: body.email,
        verified: false,
        token: makeid() + makeid() + makeid(),
      },
      state: "inactive",
      fullName: body.fullName,
      password: body.password,
      role: body.role,
      graduateYear: body.graduateYear,
      createdAt: new Date(),
      city: body.city,
      university: body.university,
      universityFaculty: body.universityFaculty,
      phone: body.phone,
      showPhone: true,
      job: body.job,
      companyName: body.companyName,
      companyAdress: body.companyAdress,
      companyPhone: body.companyPhone,
    };
  } else {
    res.status(401).send({
      success: false,
      message: "Some parameters are missing!",
    });
  }
  if (!userObj) {
    res.status(401).send({
      success: false,
      message: "Some parameters are missing!",
    });
  }
  database
    .collection("userAccounts")
    .findOne({ "email.str": body.email })
    .then(function (docs) {
      if (docs) {
        res.status(401).send({
          success: false,
          message: "Bu maile ait bir hesap bulunmaktadır!",
        });
      } else {
        database
          .collection("userAccounts")
          .insertOne(userObj, function (err, result) {
            if (err) {
              console.log(err);
              res.status(401).send({
                success: false,
                message: "An error occured!",
              });
              return;
            }
            sendEmail(
              "smtp.yandex.com.tr",
              587,
              process.env.SENDER_MAIL,
              process.env.SENDER_MAIL_PW,
              process.env.SENDER_MAIL,
              body.email,
              "ALAEV",
              "ALAEV Mail Aktivasyonu",
              "",
              activationMail(userObj.email.token)
            );
            res.json({
              success: true,
            });
          });
      }
    });
});

router.post("/login", function (req, res) {
  const body = req.body;
  const userFilter = {
    "email.str": body.email,
    password: body.password,
  };

  database
    .collection("userAccounts")
    .findOne(userFilter)
    .then(function (doc) {
      if (!doc) {
        res.status(404).send({
          success: false,
          message: "Email yada Şifreniz uyuşmamaktadır!",
        });
        return false;
      }
      if (doc.email.verified == true && doc.state === "active") {
        jwt.sign(
          { _id: doc._id, email: doc.email.str },
          process.env.JWT_SECRET_KEY,
          function (err, token) {
            if (err) {
              console.log(err);
              res.status(401).send({
                succes: false,
                message: "Bir hata oluştu!",
              });
            }
            res.json({
              token: token,
              role: doc.role,
            });
          }
        );
      } else if (doc.email.verified == false) {
        res.status(404).send({
          success: false,
          message: "Lütfen hesabınızı mailinizden aktive ediniz.",
        });
        return false;
      } else if (doc.state === "inactive") {
        res.status(404).send({
          success: false,
          message:
            "Hesabınız yöneticiler tarafından en yakın zamanda aktif edilecektir.",
        });
      }
      return;
    });
});

/*
// Update User Info
*/
router.post("/updateUserInfo", function (req, res) {
  const body = req.body;
  const token = body.token;
  const email = body.email;

  jwt.verify(token, process.env.JWT_SECRET_KEY, function (err, decoded) {
    if (err) {
      res.status(401).send({
        success: false,
        message: err.message,
      });
      throw new Error(err.message);
    } else {
      id = decoded._id;
    }
    database.collection("userAccounts").updateOne(
      { _id: id },
      {
        $set: {
          fullName: body.fullName,
          "email.str": email,
          phone: body.phone ? body.phone : "",
          companyName: body.companyName ? body.companyName : "",
          companyDiscount: body.companyDiscount ? body.companyDiscount : "",
          companyAdress: body.companyAdress ? body.companyAdress : "",
          job: body.job ? body.job : "",
          companyPhone: body.companyPhone ? body.companyPhone : "",
        },
      },
      function (error, result) {
        if (error) {
          console.log(error);
          res.status(401).send({
            success: false,
            message: "An error occured!",
          });
          return;
        } else {
          res.json({
            success: true,
            message: "Hesabınız Güncellendi!",
          });
        }
      }
    );
  });
});

router.post("/updateShowPhone", function (req, res) {
  const body = req.body;
  const token = body.token;
  const showPhone = body.showPhone;
  jwt.verify(token, process.env.JWT_SECRET_KEY, function (err, decoded) {
    if (err) {
      res.status(401).send({
        success: false,
        message: err.message,
      });
      throw new Error(err.message);
    } else {
      id = decoded._id;
    }

    database.collection("userAccounts").updateOne(
      { _id: id },
      {
        $set: {
          showPhone: showPhone,
        },
      },
      function (error, result) {
        if (error) {
          console.log(error);
          res.status(401).send({
            success: false,
            message: "An error occured!",
          });
          return;
        } else {
          res.json({
            success: true,
            message: "Hesabınız Güncellendi!",
          });
        }
      }
    );
  });
});
/*
//Forgot Password
*/
router.post("/forgotPassword", function (req, res) {
  const body = req.body;
  const emailFilter = {
    "email.str": body.email,
  };

  database
    .collection("userAccounts")
    .findOne(emailFilter)
    .then(function (doc) {
      if (!doc || doc.email.verified == false) {
        res.status(401).send({
          success: false,
          message: "Bu emaile ait bir hesap yok veya email aktive edilmemiş!",
        });
      } else {
        var token = makeid() + makeid() + makeid();
        database.collection("userAccounts").updateOne(
          { _id: doc._id },
          {
            $set: {
              "email.token": token,
            },
          },
          function (error, result) {
            if (error) {
              console.log(error);
              res.status(401).send({
                success: false,
                message: "An error occured!",
              });
              return;
            } else {
              sendEmail(
                "smtp.yandex.com.tr",
                587,
                process.env.SENDER_MAIL,
                process.env.SENDER_MAIL_PW,
                process.env.SENDER_MAIL,
                body.email,
                "ALAEV",
                "Şifremi Unuttum",
                "",
                forgotPasswordMail(token)
              );
              res.send({
                success: true,
                message: "Lütfen emailinizde gelen kutunuzu kontrol ediniz.",
              });
            }
          }
        );
      }
      //sendEmail("SMTP.office365.com", 587, "eren68401@hotmail.com", "edogruca159++123", 'Eroo', "edogruca@hotmail.com", 'DENEME', 'DENEMESUBJEXT', 'CONTENTDENEME', 'DENEME HTML');
    });
});

/*
// set Cv
*/
router.post("/setCvPage", function (req, res) {
  const body = req.body;
  const token = body.token;
  jwt.verify(token, process.env.JWT_SECRET_KEY, function (err, decoded) {
    if (err) {
      res.status(401).send({
        success: false,
        message: err.message,
      });
      throw new Error(err.message);
    } else {
      id = decoded._id;
      cvObj = {
        _id: makeid(),
        userId: id,
        cvImageUrl: body.cvImageUrl ? body.cvImageUrl : "",
        cvNameSurname: body.cvNameSurname,
        cvAge: body.cvAge,
        cvMail: body.cvMail,
        cvPhone: body.cvPhone,
        cvPersonalInfo: body.cvPersonalInfo,
        cvSchool1: body.cvSchool1,
        cvSchool2: body.cvSchool2 ? body.cvSchool2 : "",
        cvExperience1: body.cvExperience1 ? body.cvExperience1 : "",
        cvExperience2: body.cvExperience2 ? body.cvExperience2 : "",
        cvExperienceInfo: body.cvExperienceInfo ? body.cvExperienceInfo : "",
        cvReference1: body.cvReference1 ? body.cvReference1 : "",
        cvReference2: body.cvReference2 ? body.cvReference2 : "",
        cvLanguage: body.cvLanguage ? body.cvLanguage : "",
        cvSkillInfo: body.cvSkillInfo ? body.cvSkillInfo : "",
      };
      //console.log(cvObj);
      database
        .collection("cvForms")
        .findOne({ userId: id })
        .then(function (docs) {
          if (!docs) {
            if (
              body.cvNameSurname &&
              body.cvAge &&
              body.cvMail &&
              body.cvPhone &&
              body.cvSchool1
            ) {
              if (
                body.cvNameSurname != "" &&
                body.cvAge != "" &&
                body.cvMail != "" &&
                body.cvPhone != "" &&
                body.cvSchool1 != ""
              ) {
                database
                  .collection("cvForms")
                  .insertOne(cvObj, function (err, result) {
                    if (err) {
                      console.log(err);
                      res.status(401).send({
                        success: false,
                        message: "An error occured!",
                      });
                    }

                    res.json({
                      success: true,
                      message: "CV oluşturuldu.",
                    });
                  });
              } else {
                console.log("Eksik bilgi");
              }
            } else {
              res.status(401).send({
                success: false,
                message: "Bilgileri Eksiksiz Giriniz!",
              });
            }
          } else {
            // const noId = ({ _id, ...rest }) => rest
            // cvObj = noId(cvObj)
            if (
              body.cvNameSurname &&
              body.cvAge &&
              body.cvMail &&
              body.cvPhone &&
              body.cvSchool1
            ) {
              if (
                body.cvNameSurname != "" &&
                body.cvAge != "" &&
                body.cvMail != "" &&
                body.cvPhone != "" &&
                body.cvSchool1 != ""
              ) {
                database.collection("cvForms").updateOne(
                  { _id: docs._id },
                  {
                    $set: {
                      //cvObj
                      cvImageUrl: body.cvImageUrl,
                      cvNameSurname: body.cvNameSurname,
                      cvAge: body.cvAge,
                      cvMail: body.cvMail,
                      cvPhone: body.cvPhone,
                      cvPersonalInfo: body.cvPersonalInfo,
                      cvSchool1: body.cvSchool1,
                      cvSchool2: body.cvSchool2 ? body.cvSchool2 : "",
                      cvExperience1: body.cvExperience1
                        ? body.cvExperience1
                        : "",
                      cvExperience2: body.cvExperience2
                        ? body.cvExperience2
                        : "",
                      cvExperienceInfo: body.cvExperienceInfo
                        ? body.cvExperienceInfo
                        : "",
                      cvReference1: body.cvReference1 ? body.cvReference1 : "",
                      cvReference2: body.cvReference2 ? body.cvReference2 : "",
                      cvLanguage: body.cvLanguage ? body.cvLanguage : "",
                      cvSkillInfo: body.cvSkillInfo ? body.cvSkillInfo : "",
                    },
                  },
                  function (error, result) {
                    if (error) {
                      console.log(error);
                      res.status(401).send({
                        success: false,
                        message: "An error occured!",
                      });
                      return;
                    } else {
                      res.json({
                        success: true,
                        message: "Cv Güncellendi!",
                      });
                    }
                  }
                );
              } else {
                console.log("Eksik bilgi");
              }
            } else {
              res.status(401).send({
                success: false,
                message: "Bilgileri Eksiksiz Giriniz!",
              });
            }
          }
        });
    }
  });
});

/*
//Get getDiscountedtPlaces
*/
router.post("/getUserAccounts", function (req, res) {
  var body = req.body;
  var params = body.params;
  var regex = body.regex;
  var filter = body.filter;
  var projection = params.projection ? { projection: params.projection } : {};
  var data = database.collection("userAccounts").find(
    {
      $or: [
        { fullName: { $regex: new RegExp(regex, "i") }, ...filter },
        {
          phone: { $regex: new RegExp(regex, "i") },
          showPhone: true,
          ...filter,
        },
        { job: { $regex: new RegExp(regex, "i") }, ...filter },
        { university: { $regex: new RegExp(regex, "i") }, ...filter },
        { graduateYear: { $regex: new RegExp(regex, "i") }, ...filter },
        { city: { $regex: new RegExp(regex, "i") }, ...filter },
      ],
    },
    projection
  );
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }

  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

/*
//Get getDiscountedtPlaces
*/
router.post("/getDiscountedPlaces", function (req, res) {
  var body = req.body;
  var data = database
    .collection("userAccounts")
    .find({ companyDiscount: { $exists: true, $nin: ["", null] } });

  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

/*
//Get getDiscountFromId
*/
router.post("/getDiscountFromId", function (req, res) {
  var body = req.body;
  var qrContent = body.qrContent;
  database
    .collection("userAccounts")
    .findOne({ _id: qrContent })
    .then(function (doc) {
      if (!doc) {
        res.status(404).send({
          success: false,
          message: "User not found!",
        });
        return false;
      }
      if (!doc.companyDiscount) {
        res.status(404).send({
          success: false,
          message: "Wrong user type!",
        });
        return false;
      } else {
        res.json(
          doc.companyName + " için " + "%" + doc.companyDiscount + " indirim!"
        );
        return;
      }
    });
});

/*
//Get getAdversitements
*/
router.post("/getAdvertisements", function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var projection = params.projection ? { projection: params.projection } : {};
  var data = database.collection("advertisements").find(filter, projection);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

/*
//Get getAdversitement
*/
router.post("/getAdvertisement", function (req, res) {
  var body = req.body;
  var filter = body.filter;
  database
    .collection("advertisements")
    .findOne(filter)
    .then(function (doc) {
      if (!doc) {
        res.status(404).send({
          success: false,
          message: "Post not found!",
        });
        return false;
      }
      res.json(doc);
      return;
    });
});

/*
//Set Job Adversitement
*/
router.post("/setJobAdRequest", function (req, res) {
  const body = req.body;
  const token = body.token;
  jwt.verify(token, process.env.JWT_SECRET_KEY, function (err, decoded) {
    if (err) {
      res.status(401).send({
        success: false,
        message: err.message,
      });
      throw new Error(err.message);
    } else {
      id = decoded._id;
      database
        .collection("userAccounts")
        .findOne({ _id: id })
        .then(function (docs) {
          companyName = body.companyName;
          fullName = docs.fullName;
          jobAdObj = {
            _id: body._id ? body._id : makeid(),
            createdAt: new Date(),
            state: "inactive",
            userId: id,
            fullName: fullName,
            companyName: companyName,
            jobAdImageUrl: body.jobAdImageUrl,
            jobAdTitle: body.jobAdTitle,
            jobAdCompanyNumber: body.jobAdCompanyNumber,
            jobAdPersonalNumber: body.jobAdPersonalNumber,
            jobAdMail: body.jobAdMail,
            jobAdContent: body.jobAdContent,
            jobAdType: body.jobAdType,
            jobAdDiploma: body.jobAdDiploma,
            city: body.city,
            jobType: body.jobType,
          };
          database
            .collection("jobAdForms")
            .findOne({ _id: body._id })
            .then(function (docs) {
              if (!docs) {
                if (body.jobAdTitle && body.jobAdContent && body.jobType) {
                  if (
                    body.jobAdTitle != "" &&
                    body.jobAdContent != "" &&
                    body.jobAdMail != ""
                  ) {
                    database
                      .collection("jobAdForms")
                      .insertOne(jobAdObj, function (err, result) {
                        if (err) {
                          console.log(err);
                          res.status(401).send({
                            success: false,
                            message: "An error occured!",
                          });
                        }
                        res.json({
                          success: true,
                          message:
                            "İş ilanı oluşturuldu. Lütfen ilanınızı aktif duruma getirmek için yöneticiyle iletişime geçiniz! ",
                        });
                      });
                  } else {
                    console.log("Eksik bilgi");
                  }
                } else {
                  res.status(401).send({
                    success: false,
                    message: "Bilgileri Eksiksiz Giriniz!",
                  });
                }
              } else {
                if (body.jobAdTitle && body.jobAdContent) {
                  if (body.jobAdTitle != "" && body.jobAdContent != "") {
                    database.collection("jobAdForms").updateOne(
                      { _id: docs._id },
                      {
                        $set: {
                          state: "inactive",
                          fullName: fullName,
                          companyName: companyName,
                          jobAdImageUrl: body.jobAdImageUrl
                            ? body.jobAdImageUrl
                            : "",
                          jobAdTitle: body.jobAdTitle,
                          jobAdCompanyNumber: body.jobAdCompanyNumber,
                          jobAdPersonalNumber: body.jobAdPersonalNumber
                            ? body.jobAdPersonalNumber
                            : "",
                          jobAdMail: body.jobAdMail ? body.jobAdMail : "",
                          jobAdContent: body.jobAdContent,
                          jobAdType: body.jobAdType,
                          jobAdDiploma: body.jobAdDiploma,
                          city: body.city,
                          jobType: body.jobType,
                        },
                      },
                      function (error, result) {
                        if (error) {
                          console.log(error);
                          res.status(401).send({
                            success: false,
                            message: "An error occured!",
                          });
                          return;
                        } else {
                          res.json({
                            success: true,
                            message:
                              "İş ilanı güncellendi. Lütfen ilanınızı aktif duruma getirmek için yöneticiyle iletişime geçiniz!",
                          });
                        }
                      }
                    );
                  } else {
                    console.log("Eksik bilgi");
                  }
                } else {
                  res.status(401).send({
                    success: false,
                    message: "Bilgileri Eksiksiz Giriniz!",
                  });
                }
              }
            });
        });
    }
  });
});

/*
//Get getJobAdvs
*/
router.post("/getJobAdvs", function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var projection = params.projection ? { projection: params.projection } : {};
  var data = database.collection("jobAdForms").find(filter, projection);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }

  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    console.log(docs);
    res.json(docs);
  });
});

/*
//Get getUserJobAdvs
*/
router.post("/getUserJobAdvs", function (req, res) {
  var body = req.body;
  var token = body.token;
  var filter = body.filter;
  var params = body.params;
  var id;

  jwt.verify(token, process.env.JWT_SECRET_KEY, function (err, decoded) {
    if (err) {
      res.status(401).send({
        success: false,
        message: err.message,
      });
      throw new Error(err.message);
    } else {
      id = decoded._id;
      filter = { userId: id };
    }
  });
  var data = database.collection("jobAdForms").find(filter);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});
/*
//Get getUserJob
*/
router.post("/getUserJob", function (req, res) {
  var body = req.body;
  var token = body.token;
  var userId;
  var filter = body.filter;
  var params = body.params;
  var projection = params.projection ? { projection: params.projection } : {};
  jwt.verify(token, process.env.JWT_SECRET_KEY, function (err, decoded) {
    if (err) {
      res.status(401).send({
        success: false,
        message: err.message,
      });
      throw new Error(err.message);
    } else {
      console.log(decoded);
      userId = decoded._id;
      filter = {
        userId: userId,
        _id: body._id,
      };
      console.log(filter);
      database
        .collection("jobAdForms")
        .findOne(filter)
        .then(function (docs) {
          console.log(docs);
          res.json(docs);
        });
    }
  });
});

/*
//Set Company Adversitement
*/
router.post("/setCompanyAdRequest", function (req, res) {
  const body = req.body;
  const token = body.token;
  var companyName = body.companyName;
  var companyAdObj;
  jwt.verify(token, process.env.JWT_SECRET_KEY, function (err, decoded) {
    if (err) {
      res.status(401).send({
        success: false,
        message: err.message,
      });
      throw new Error(err.message);
    } else {
      id = decoded._id;
      database
        .collection("userAccounts")
        .findOne({ _id: id })
        .then(function (docs) {
          companyName = companyName;
          companyAdObj = {
            _id: body._id ? body._id : makeid(),
            createdAt: new Date(),
            state: "inactive",
            userId: id,
            companyName: companyName,
            companyAdImageUrl: body.companyAdImageUrl,
            companyAdTitle: body.companyAdTitle,
            companyAdCompanyNumber: body.companyAdCompanyNumber,
            companyAdPersonalNumber: body.companyAdPersonalNumber,
            companyAdMail: body.companyAdMail,
            companyAdContent: body.companyAdContent,
          };
          console.log(companyAdObj, "ASDADS");
          database
            .collection("companyAdForms")
            .findOne({ _id: body._id })
            .then(function (docs) {
              if (!docs) {
                if (
                  body.companyAdTitle &&
                  body.companyAdCompanyNumber &&
                  body.companyAdContent
                ) {
                  if (
                    body.companyAdTitle != "" &&
                    body.companyAdCompanyNumber != "" &&
                    body.companyAdContent != ""
                  ) {
                    database
                      .collection("companyAdForms")
                      .insertOne(companyAdObj, function (err, result) {
                        if (err) {
                          console.log(err);
                          res.status(401).send({
                            success: false,
                            message: "An error occured!",
                          });
                        }
                        res.json({
                          success: true,
                          message:
                            "İlan oluşturuldu. Lütfen ilanınızı aktif duruma getirmek için yöneticiyle iletişime geçiniz.",
                        });
                      });
                  } else {
                    console.log("Eksik bilgi");
                  }
                } else {
                  console.log("boşşş");
                  res.status(401).send({
                    success: false,
                    message: "Firma Bilgileri Eksiksiz Giriniz!",
                  });
                }
              } else {
                if (
                  body.companyAdTitle &&
                  body.companyAdCompanyNumber &&
                  body.companyAdContent
                ) {
                  if (
                    body.companyAdTitle != "" &&
                    body.companyAdCompanyNumber != "" &&
                    body.companyAdContent != ""
                  ) {
                    database.collection("companyAdForms").updateOne(
                      { _id: docs._id },
                      {
                        $set: {
                          companyAdImageUrl: body.companyAdImageUrl
                            ? body.companyAdImageUrl
                            : "",
                          state: "inactive",
                          companyAdTitle: body.companyAdTitle,
                          companyAdCompanyNumber: body.companyAdCompanyNumber,
                          companyAdPersonalNumber: body.companyAdPersonalNumber
                            ? body.companyAdPersonalNumber
                            : "",
                          companyAdMail: body.companyAdMail
                            ? body.companyAdMail
                            : "",
                          companyAdContent: body.companyAdContent,
                        },
                      },
                      function (error, result) {
                        if (error) {
                          console.log(error);
                          res.status(401).send({
                            success: false,
                            message: "An error occured!",
                          });
                          return;
                        } else {
                          res.json({
                            success: true,
                            message:
                              "İlan güncellendi. Lütfen ilanınızı aktif duruma getirmek için yöneticiyle iletişime geçiniz.",
                          });
                        }
                      }
                    );
                  } else {
                    console.log("Eksik bilgi");
                  }
                } else {
                  console.log("boşşş");
                  res.status(401).send({
                    success: false,
                    message: "Bilgileri Eksiksiz Giriniz!",
                  });
                }
              }
            });
        });
    }
  });
});

/*
//Get getCompanyAdvs
*/
router.post("/getCompanyAdvs", function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var projection = params.projection ? { projection: params.projection } : {};
  var data = database.collection("companyAdForms").find(filter, projection);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    console.log(docs);
    res.json(docs);
  });
});

/*
//Get getUserAdv
*/
router.post("/getUserAdv", function (req, res) {
  var body = req.body;
  var token = body.token;
  var userId;
  var filter = body.filter;
  var params = body.params;
  var projection = params.projection ? { projection: params.projection } : {};
  jwt.verify(token, process.env.JWT_SECRET_KEY, function (err, decoded) {
    if (err) {
      res.status(401).send({
        success: false,
        message: err.message,
      });
      throw new Error(err.message);
    } else {
      console.log(decoded);
      userId = decoded._id;
      filter = {
        userId: userId,
        _id: body._id,
      };
      console.log(filter);
      database
        .collection("companyAdForms")
        .findOne(filter)
        .then(function (docs) {
          console.log(docs);
          res.json(docs);
        });
    }
  });
});

/*
//Get getUserCompanyAdvs
*/
router.post("/getUserCompanyAdvs", function (req, res) {
  var body = req.body;
  var token = body.token;
  var filter = body.filter;
  var params = body.params;
  var id;

  jwt.verify(token, process.env.JWT_SECRET_KEY, function (err, decoded) {
    if (err) {
      res.status(401).send({
        success: false,
        message: err.message,
      });
      throw new Error(err.message);
    } else {
      id = decoded._id;
      filter = { userId: id };
    }
  });
  var data = database.collection("companyAdForms").find(filter);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

/*
//Get getCompanySupply
*/
// router.post("/getCompanySupply", function (req, res) {
//     var body = req.body;
//     var filter = body.filter;
//     database
//         .collection("companySupplies")
//         .findOne(filter)
//         .then(function (doc) {
//             if (!doc) {
//                 res.status(404).send({
//                     success: false,
//                     message: "Post not found!",
//                 });
//                 return false;
//             }
//             res.json(doc);
//             return;
//         });
// });

/*
//Get User Data
*/
router.post("/getUserData", function (req, res) {
  var body = req.body;
  var token = body.token;

  jwt.verify(token, process.env.JWT_SECRET_KEY, function (err, decoded) {
    if (err) {
      res.status(401).send({
        success: false,
        message: err.message,
      });
      throw new Error(err.message);
    } else {
      console.log(decoded);
      id = decoded._id;
      database
        .collection("userAccounts")
        .findOne({ _id: id })
        .then(function (docs) {
          console.log(docs);
          res.json(docs);
        });
    }
  });
});

/*
//getAppliedUserData
*/

router.post("/getAppliedUserData", function (req, res) {
  var body = req.body;
  if (body) {
    database
      .collection("jobAdForms")
      .findOne({ _id: body._id })
      .then(function (docs) {
        if (docs && docs.appliedUsers) {
          database
            .collection("cvForms")
            .find(
              { userId: { $in: docs.appliedUsers } },
              function (error, result) {
                if (error) {
                  res.status(401).send({
                    success: false,
                    message: "Cv Bulunamadı",
                  });
                } else {
                  result.toArray(function (error, result) {
                    if (error) {
                      res.status(401).send({
                        success: false,
                        message: "An error occured!",
                      });
                      return;
                    }
                    res.json(result);
                  });
                }
              }
            );
        } else {
          console.log("ads1");
          res.status(401).send({
            success: false,
            message: "Beklenmedik bir hata oluştu!",
          });
        }
      });
  } else {
    console.log("ads");
    res.status(401).send({
      success: false,
      message: "An error occured!",
    });
  }
});

/*
//Get Job Cv Data
*/
router.post("/getJobCvData", function (req, res) {
  var body = req.body;

  if (body) {
    database
      .collection("jobAdForms")
      .findOne({ _id: body._id })
      .then(function (docs) {
        if (docs) {
          database
            .collection("cvForms")
            .find({ userId: docs.userId }, function (error, result) {
              if (error) {
                res.status(401).send({
                  success: false,
                  message: "Cv Bulunamadı",
                });
              } else {
                result.toArray(function (error, result) {
                  if (error) {
                    res.status(401).send({
                      success: false,
                      message: "An error occured!",
                    });
                    return;
                  }
                  res.json(result);
                });
              }
            });
        } else {
          res.status(401).send({
            success: false,
            message: "Beklenmedik bir hata oluştu!",
          });
        }
      });
  }
});

/*
//Get User Cv Data
*/
router.post("/getUserCvData", function (req, res) {
  var body = req.body;
  var token = body.token;

  jwt.verify(token, process.env.JWT_SECRET_KEY, function (err, decoded) {
    if (err) {
      res.status(401).send({
        success: false,
        message: err.message,
      });
      throw new Error(err.message);
    } else {
      console.log(decoded);
      id = decoded._id;
      database
        .collection("cvForms")
        .findOne({ userId: id })
        .then(function (docs) {
          if (!docs) {
            res.status(401).send({
              message: "Kullanıcıya ait CV verisi bulunmamaktadır!",
            });
          } else {
            res.json(docs);
          }
        });
    }
  });
});
/*
//Get User Cv Data
*/
router.post("/getUserCvDataById", function (req, res) {
  var body = req.body;
  var id = body.id;
  console.log(id);
  database
    .collection("cvForms")
    .findOne({ userId: id })
    .then(function (docs) {
      if (!docs) {
        res.status(401).send({
          message: "Kullanıcıya ait CV verisi bulunmamaktadır!",
        });
      } else {
        res.json(docs);
      }
    });
});

/*
//Apply Job Ad
*/
router.post("/applyJobAd", function (req, res) {
  var body = req.body;
  var token = body.token;

  jwt.verify(token, process.env.JWT_SECRET_KEY, function (err, decoded) {
    if (err) {
      res.status(401).send({
        success: false,
        message: err.message,
      });
      throw new Error(err.message);
    } else {
      console.log(decoded);
      userId = decoded._id;
      database
        .collection("cvForms")
        .findOne({ userId: userId })
        .then(function (doc) {
          if (!doc) {
            res.status(401).send({
              success: false,
              message: "Cv'niz Bulunamadı!",
            });
          } else {
            database
              .collection("jobAdForms")
              .findOne({ _id: body._id })
              .then(function (doc) {
                if (doc) {
                  if (doc.appliedUsers) {
                    var isExist = false;
                    doc.appliedUsers.map(function (v, i) {
                      if (v == userId) {
                        isExist = true;
                        res.status(401).send({
                          success: false,
                          message: "Daha önce başvuru yapmışsınız!",
                        });
                      }
                    });
                    if (!isExist) {
                      var appliedArr = doc.appliedUsers;
                      appliedArr.push(userId);
                      database.collection("jobAdForms").updateOne(
                        { _id: body._id },
                        {
                          $set: {
                            appliedUsers: appliedArr,
                          },
                        },
                        function (error, result) {
                          if (error) {
                            res.status(401).send({
                              success: false,
                              message: "Beklenmedik bir hata oluştu!",
                            });
                          } else {
                            res.send({
                              success: true,
                              message: "Başvuru Yapıldı!",
                            });
                          }
                        }
                      );
                    }
                  } else {
                    database.collection("jobAdForms").updateOne(
                      { _id: body._id },
                      {
                        $set: {
                          appliedUsers: [userId],
                        },
                      },
                      function (error, result) {
                        if (error) {
                          res.status(401).send({
                            success: false,
                            message: "Beklenmedik bir hata oluştu!",
                          });
                        } else {
                          res.send({
                            success: true,
                            message: "Başvuru Yapıldı!",
                          });
                        }
                      }
                    );
                  }
                }
              });
          }
        });
    }
  });
});

/*
//Get getSiteImageFolder
*/
router.post("/getSiteImageFolder", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;

  if (!filter.domainId) {
    missingParams(res);
  }

  database
    .collection("domains")
    .findOne({
      _id: filter.domainId,
    })
    .then(function (docs) {
      res.json(docs.siteImageUrl);
    });
});

/*
//Get Config
*/
router.post("/config", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;

  if (!filter.domainName || !filter.language) {
    missingParams(res);
  }

  database
    .collection("domains")
    .findOne({
      name: filter.domainName,
    })
    .then(function (doc) {
      if (!doc) {
        res.status(401).send({
          success: false,
          message: "Domain not found!",
        });
        return false;
      }
      database
        .collection("config")
        .findOne({
          domainId: doc._id,
          language: filter.language,
        })
        .then(function (docs) {
          res.json(
            Object.assign(
              {
                domainId: doc._id,
              },
              docs
            )
          );
        });
    });
});

/*
//GetPages
*/
router.post("/page", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  database
    .collection("pages")
    .findOne(filter)
    .then(function (doc) {
      if (!doc) {
        res.status(404).send({
          success: false,
          message: "Page not found!",
        });
        return false;
      }
      res.json(doc);
      return;
    });
});
router.post("/pages", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var projection = params.projection ? { projection: params.projection } : {};
  var data = database.collection("pages").find(filter, projection);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

/*
//GetPosts
*/
router.post("/post", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  database
    .collection("posts")
    .findOne(filter)
    .then(function (doc) {
      if (!doc) {
        res.status(404).send({
          success: false,
          message: "Post not found!",
        });
        return false;
      }
      res.json(doc);
      return;
    });
});
router.post("/posts", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var projection = params.projection ? { projection: params.projection } : {};
  var data = database.collection("posts").find(filter, projection);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

/*
//Get Posts By Post Type  
*/
router.post("/getPostsByPostTypeName", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var projection = params.projection ? { projection: params.projection } : {};
  if (!filter.language) {
    missingParams(res);
  }
  database
    .collection("postTypes")
    .findOne(filter)
    .then(function (doc) {
      if (!doc) {
        res.status(401).send({
          success: false,
          message: "Post type not found!",
        });
        return false;
      }
      var data = database.collection("posts").find(
        {
          postType: doc._id,
          language: filter.language,
          domainId: filter.domainId,
        },
        projection
      );
      if (params.sort) {
        data = data.sort(params.sort);
      }
      if (params.limit) {
        data = data.limit(params.limit);
      }
      data.toArray(function (err, docs) {
        if (err) {
          res.status(401).send({
            success: false,
            message: "An error occured!",
          });
          return;
        }
        res.json(docs);
      });
    });
});

/*
//Get Posts By Post Cat  
*/
router.post("/getPostsByPostCatName", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var projection = params.projection ? { projection: params.projection } : {};
  if (!filter.language) {
    missingParams(res);
  }
  database
    .collection("postCategories")
    .findOne(filter)
    .then(function (doc) {
      if (!doc) {
        res.status(401).send({
          success: false,
          message: "Post cat not found!",
        });
        return false;
      }
      var data = database.collection("posts").find(
        {
          cat: doc._id,
          language: filter.language,
          domainId: filter.domainId,
        },
        projection
      );
      if (params.sort) {
        data = data.sort(params.sort);
      }
      if (params.limit) {
        data = data.limit(params.limit);
      }
      data.toArray(function (err, docs) {
        if (err) {
          res.status(401).send({
            success: false,
            message: "An error occured!",
          });
          return;
        }
        res.json(docs);
      });
    });
});

/*
//GetPostByPostCatId
*/
router.post("/getPostsByPostCatId", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var projection = params.projection ? { projection: params.projection } : {};
  if (!filter.language) {
    missingParams(res);
  }

  var data = database.collection("posts").find(
    {
      cat: filter.cat,
      language: filter.language,
      domainId: filter.domainId,
    },
    projection
  );
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

/*
//GetPostCategory
*/
router.post("/postCategory", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var projection = params.projection ? { projection: params.projection } : {};
  database
    .collection("postCategories")
    .findOne(filter, projection)
    .then(function (doc) {
      if (!doc) {
        res.status(404).send({
          success: false,
          message: "Post category not found!",
        });
        return false;
      }
      res.json(doc);
      return;
    });
});
router.post("/postCategories", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var projection = params.projection ? { projection: params.projection } : {};
  var data = database.collection("postCategories").find(filter, projection);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

/*
//GetPostCategory By CatName
*/

router.post("/getPostCatByPostCatAlias", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var projection = params.projection ? { projection: params.projection } : {};
  if (!filter.language) {
    missingParams(res);
  }
  database
    .collection("postCategories")
    .findOne(filter)
    .then(function (doc) {
      if (!doc) {
        res.status(401).send({
          success: false,
          message: "Post type not found!",
        });
        return false;
      }
      var data = database.collection("postCategories").find(
        {
          cat: doc._id,
          language: filter.language,
          domainId: filter.domainId,
        },
        projection
      );
      if (params.sort) {
        data = data.sort(params.sort);
      }
      if (params.limit) {
        data = data.limit(params.limit);
      }
      data.toArray(function (err, docs) {
        if (err) {
          res.status(401).send({
            success: false,
            message: "An error occured!",
          });
          return;
        }
        res.json(docs);
      });
    });
});

/*
//GetPostType
*/
router.post("/postType", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  database
    .collection("postTypes")
    .findOne(filter)
    .then(function (doc) {
      if (!doc) {
        res.status(404).send({
          success: false,
          message: "Post type not found!",
        });
        return false;
      }
      res.json(doc);
      return;
    });
});
router.post("/postTypes", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var data = database.collection("postTypes").find(filter);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

/*
//GetMenus
*/
router.post("/menu", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  database
    .collection("menus")
    .findOne(filter)
    .then(function (doc) {
      if (!doc) {
        res.status(404).send({
          success: false,
          message: "Menu not found!",
        });
        return false;
      }
      res.json(doc);
      return;
    });
});
router.post("/menus", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var data = database.collection("menus").find(filter);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

/*
//GetBlocks
*/
router.post("/block", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  database
    .collection("blocks")
    .findOne(filter)
    .then(function (doc) {
      if (!doc) {
        res.status(404).send({
          success: false,
          message: "Block not found!",
        });
        return false;
      }
      res.json(doc);
      return;
    });
});
router.post("/blocks", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var data = database.collection("blocks").find(filter);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

/*
//GetSettings
*/
router.post("/settings", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var data = database.collection("settings").find(filter);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

/*
//GetSlides
*/
router.post("/slides", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var data = database.collection("slides").find(filter);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

/*
//GetSlidesByName
*/
router.post("/getSliderByName", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var data = database.collection("slides").find(filter);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

/*
//GetGallery
*/
router.post("/galleries", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  delete filter.language;
  var data = database.collection("galleries").find(filter);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

/*
//GetProduct
*/
router.post("/product", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  database
    .collection("products")
    .findOne(filter)
    .then(function (doc) {
      if (!doc) {
        res.status(404).send({
          success: false,
          message: "Product not found!",
        });
        return false;
      }
      res.json(doc);
      return;
    });
});
router.post("/products", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var projection = params.projection ? { projection: params.projection } : {};
  var data = database.collection("products").find(filter, projection);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

/*
//GetProductCategory
*/
router.post("/productCategory", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  database
    .collection("productCategories")
    .findOne(filter)
    .then(function (doc) {
      if (!doc) {
        res.status(404).send({
          success: false,
          message: "Product not found!",
        });
        return false;
      }
      res.json(doc);
      return;
    });
});
router.post("/productCategories", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var projection = params.projection ? { projection: params.projection } : {};
  var data = database.collection("productCategories").find(filter, projection);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

router.post(
  "/getProductsByCategoryAlias",
  isAuthenticated,
  function (req, res) {
    var body = req.body;
    var filter = body.filter;
    var params = body.params;
    if (!filter.alias || !filter.language) {
      missingParams(res);
    }
    database
      .collection("productCategories")
      .findOne({
        alias: filter.alias,
      })
      .then(function (doc) {
        if (!doc) {
          res.status(401).send({
            success: false,
            message: "Product category not found!",
          });
          return false;
        }
        var data = database.collection("products").find({
          cat: doc._id,
          language: filter.language,
        });
        if (params.sort) {
          data = data.sort(params.sort);
        }
        if (params.limit) {
          data = data.limit(params.limit);
        }
        data.toArray(function (err, docs) {
          if (err) {
            res.status(401).send({
              success: false,
              message: "An error occured!",
            });
            return;
          }
          res.json(
            Object.assign(doc, {
              products: docs,
            })
          );
        });
      });
  }
);

router.post("/getProductsByCategoryId", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var projection = params.projection ? { projection: params.projection } : {};
  if (!filter.language) {
    missingParams(res);
  }
  database
    .collection("productCategories")
    .findOne({
      _id: filter._id,
    })
    .then(function (doc) {
      if (!doc) {
        res.status(401).send({
          success: false,
          message: "Product category not found!",
        });
        return false;
      }
      var data = database.collection("products").find(
        {
          cat: doc._id,
          language: filter.language,
        },
        projection
      );
      if (params.sort) {
        data = data.sort(params.sort);
      }
      if (params.limit) {
        data = data.limit(params.limit);
      }
      data.toArray(function (err, docs) {
        if (err) {
          res.status(401).send({
            success: false,
            message: "An error occured!",
          });
          return;
        }
        res.json(
          Object.assign(doc, {
            products: docs,
          })
        );
      });
    });
});

/*
//Solutions
*/
router.post("/solution", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  database
    .collection("solutions")
    .findOne(filter)
    .then(function (doc) {
      if (!doc) {
        res.status(404).send({
          success: false,
          message: "Solution not found!",
        });
        return false;
      }
      res.json(doc);
      return;
    });
});
router.post("/solutions", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var data = database.collection("solutions").find(filter);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});

/*
//Solution Categories
*/
router.post("/solutionCategory", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  database
    .collection("solutionCategories")
    .findOne(filter)
    .then(function (doc) {
      if (!doc) {
        res.status(404).send({
          success: false,
          message: "Solution category not found!",
        });
        return false;
      }
      res.json(doc);
      return;
    });
});
router.post("/solutionCategories", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var data = database.collection("solutionCategories").find(filter);
  if (params.sort) {
    data = data.sort(params.sort);
  }
  if (params.limit) {
    data = data.limit(params.limit);
  }
  data.toArray(function (err, docs) {
    if (err) {
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json(docs);
  });
});
router.post(
  "/getSolutionsByCategoryAlias",
  isAuthenticated,
  function (req, res) {
    var body = req.body;
    var filter = body.filter;
    var params = body.params;
    if (!filter.alias || !filter.language) {
      missingParams(res);
    }
    database
      .collection("solutionCategories")
      .findOne({
        alias: filter.alias,
      })
      .then(function (doc) {
        if (!doc) {
          res.status(401).send({
            success: false,
            message: "Solution category not found!",
          });
          return false;
        }
        var data = database.collection("solutions").find({
          cat: doc._id,
          language: filter.language,
        });
        if (params.sort) {
          data = data.sort(params.sort);
        }
        if (params.limit) {
          data = data.limit(params.limit);
        }
        data.toArray(function (err, docs) {
          if (err) {
            res.status(401).send({
              success: false,
              message: "An error occured!",
            });
            return;
          }
          res.json(
            Object.assign(doc, {
              solutions: docs,
            })
          );
        });
      });
  }
);

/*
//Search
*/
router.post("/search", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;
  var collections = params.collections;
  if (!collections || collections.length == 0) {
    res.status(404).send({
      success: false,
      message: "Nothing found!",
    });
    return false;
  }
  if (params.keyword.length < 2) {
    res.status(404).send({
      success: false,
      message: "Nothing found!",
    });
    return false;
  }
  database.listCollections().toArray(function (err, collInfos) {
    // collInfos is an array of collection info objects that look like:
    // { name: 'test', options: {} }
    var results = [];
    var waitStack = 0;
    function getDataFromCollection(col) {
      var keyword = params.keyword.replace(/[İi]/g, "[İ|i]");
      database
        .collection(col)
        .find(
          Object.assign(filter, { title: { $regex: keyword, $options: "i" } })
        )
        .toArray(function (err, result) {
          if (!err) {
            results.push({ collection: col, result: result });
            waitStack--;
            if (waitStack == 0) {
              res.json(results);
            }
          } else {
            res.status(401).send({
              success: false,
              message: "An error occured!",
            });
            return;
          }
        });
    }
    for (var collection of collections) {
      if (
        collInfos.find((x) => x.name == collection && x.type == "collection")
      ) {
        waitStack++;
        getDataFromCollection(collection);
      }
    }
  });
});

//save form service
COUNTER = new Date().getTime();
router.post("/saveForm", isAuthenticated, function (req, res) {
  var body = req.body;
  if (!body.filter.formId || !body.filter.serialize || !body.filter.domainId) {
    missingParams(res);
    return;
  }
  var formId = body.filter.formId;
  var serialize = body.filter.serialize;

  var time = new Date().getTime();
  if (time - COUNTER < 1500) {
    throw new Error(403, "Too much request!");
  }
  COUNTER = new Date().getTime();

  var obj = {
    _id: makeid(),
    createdAt: new Date(),
    formId: formId,
    serialize: serialize,
    ip: req.connection.remoteAddress,
    domainId: body.filter.domainId,
  };
  database.collection("forms").insertOne(obj, function (err, result) {
    if (err) {
      console.log(err);
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json({
      success: true,
    });
  });
});

router.post("/savePayment", isAuthenticated, function (req, res) {
  var body = req.body;
  if (!body.filter || !body.filter.domainId) {
    missingParams(res);
    return;
  }
  var paymentObj = body.filter.paymentObj;

  var time = new Date().getTime();
  if (time - COUNTER < 1500) {
    throw new Error(403, "Too much request!");
  }
  COUNTER = new Date().getTime();

  var obj = {
    _id: makeid(),
    createdAt: new Date(),
    ip: req.connection.remoteAddress,
    domainId: body.filter.domainId,
    ...paymentObj,
  };
  database.collection("payments").insertOne(obj, function (err, result) {
    if (err) {
      console.log(err);
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json({
      success: true,
    });
  });
});

router.post("/getPayment", isAuthenticated, function (req, res) {
  var body = req.body;
  if (!body.filter || !body.filter.domainId) {
    missingParams(res);
    return;
  }
  var filter = body.filter;
  database
    .collection("payments")
    .findOne(filter)
    .then(function (doc) {
      if (!doc) {
        res.status(404).send({
          success: false,
          message: "Solution category not found!",
        });
        return false;
      }
      res.json(doc);
      return;
    });
});

router.post("/updateStatus", isAuthenticated, function (req, res) {
  var body = req.body;
  if (!body.filter || !body.filter.domainId) {
    missingParams(res);
    return;
  }
  var filter = body.filter;
  return database.collection("payments").updateOne(
    { conversationId: filter.conversationId },
    {
      $set: { status: true },
    }
  );
});

/*
 ***Reservation
 */

COUNTER = new Date().getTime();
router.post("/saveReservation", isAuthenticated, function (req, res) {
  var body = req.body;
  if (!body.filter.formId || !body.filter.serialize || !body.filter.domainId) {
    missingParams(res);
    return;
  }
  var formId = body.filter.formId;
  var serialize = body.filter.serialize;

  var time = new Date().getTime();
  if (time - COUNTER < 1500) {
    throw new Error(403, "Too much request!");
  }
  COUNTER = new Date().getTime();

  var obj = {
    _id: makeid(),
    createdAt: new Date(),
    formId: formId,
    serialize: serialize,
    ip: req.connection.remoteAddress,
    domainId: body.filter.domainId,
  };
  database.collection("reservations").insertOne(obj, function (err, result) {
    if (err) {
      console.log(err);
      res.status(401).send({
        success: false,
        message: "An error occured!",
      });
      return;
    }
    res.json({
      success: true,
    });
  });
});

//send email
router.post("/sendEmail", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;

  if (!filter.domainId || !params) {
    missingParams(res);
    return;
  }
  database
    .collection("config")
    .findOne({
      domainId: filter.domainId,
    })
    .then(function (docs) {
      if (
        docs &&
        docs.mailUserName &&
        docs.mailPassword &&
        docs.smtpServer &&
        docs.smtpPort &&
        params.from &&
        params.to &&
        params.name &&
        params.subject &&
        params.contentText &&
        params.contentHTML
      ) {
        if (
          docs.mailUserName != "" &&
          docs.mailPassword != "" &&
          docs.smtpServer != "" &&
          docs.smtpPort != "" &&
          params.from != "" &&
          params.to != "" &&
          params.name != "" &&
          params.subject != "" &&
          params.contentText != "" &&
          params.contentHTML != ""
        ) {
          sendEmail(
            docs.smtpServer,
            docs.smtpPort,
            docs.mailUserName,
            docs.mailPassword,
            params.from,
            params.to,
            params.name,
            params.subject,
            params.contentText,
            params.contentHTML
          )
            .then(function (result) {
              res.json({
                success: true,
              });
            })
            .catch(function (error) {
              logIt("error on mail send", error);
              res.json({
                success: false,
                error: error,
              });
            });
        } else {
          res.json({
            success: false,
          });
        }
      } else {
        res.json({
          success: false,
        });
      }
    });
});

router.post("/sendEmailTo", isAuthenticated, function (req, res) {
  var body = req.body;
  var filter = body.filter;
  var params = body.params;

  if (!filter.domainId || !params) {
    missingParams(res);
    return;
  }
  console.log("mail gidecek", params);
  database
    .collection("config")
    .findOne({
      domainId: filter.domainId,
    })
    .then(function (docs) {
      if (
        docs &&
        docs.mailUserName &&
        docs.mailPassword &&
        docs.smtpServer &&
        docs.smtpPort &&
        params.from &&
        params.to &&
        params.subject &&
        params.contentText &&
        params.contentHTML
      ) {
        if (
          docs.mailUserName != "" &&
          docs.mailPassword != "" &&
          docs.smtpServer != "" &&
          docs.smtpPort != "" &&
          params.from != "" &&
          params.to != "" &&
          params.subject != "" &&
          params.contentText != "" &&
          params.contentHTML != ""
        ) {
          sendEmail(
            docs.smtpServer,
            docs.smtpPort,
            docs.mailUserName,
            docs.mailPassword,
            params.from,
            params.to,
            "",
            params.subject,
            params.contentText,
            params.contentHTML
          )
            .then(function (result) {
              res.json({
                success: true,
              });
            })
            .catch(function (error) {
              logIt("error on mail send", error);
              res.json({
                success: false,
                error: error,
              });
            });
        } else {
          res.json({
            success: false,
          });
        }
      } else {
        res.json({
          success: false,
        });
      }
    });
});
app.use("/api", router);

http.listen(httpPort, function () {
  console.log("Node server running on port 2000 without SSL");
});

function isAuthenticated(req, res, next) {
  return next();
  /*
    if(req.headers.hasOwnProperty('nano-token')){
        var token = Buffer.from(req.headers['nano-token'], 'base64').toString('utf-8');
        if(token && token.length>0){
            var pieces = token.split(SEPERATOR);
            if(pieces.length == 2){
                var susername = pieces[0];
                var spassword = pieces[1];
                checkLocalLogin(susername,spassword,function (result) {
                    if(result){
                        return next();
                    }
                    else{
                        res.status(401).send({ success: false, message: 'Unauthorized' })
                    }
                });
            }
            else{
                res.status(401).send({ success: false, message: 'Unauthorized' })
            }
        }
        else{
            res.status(401).send({ success: false, message: 'Unauthorized' })
        }
    }
    else{
        res.status(401).send({ success: false, message: 'Unauthorized' })
    }*/
}

function missingParams(res) {
  res.status(401).send({
    success: false,
    message: "Some parameters not found!",
  });
  throw new Error("Some parameters not found!");
}
function makeid() {
  var text = "";
  var possible =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

  for (var i = 0; i < 17; i++)
    text += possible.charAt(Math.floor(Math.random() * possible.length));

  return text;
}
async function sendEmail(
  host,
  port,
  user,
  pass,
  from,
  to,
  name,
  subject,
  contentText,
  contentHTML
) {
  // create reusable transporter object using the default SMTP transport
  console.log("sendMail");
  let transporter = nodemailer.createTransport({
    host: host,
    port: port,
    secure: false,
    auth: {
      user: user,
      pass: pass,
    },
  });
  // setup email data with unicode symbols
  let mailOptions = {
    from: '"' + name + '" <' + from + ">", // sender address
    to: to, // list of receivers
    subject: subject, // Subject line
    text: contentText, // plain text body
    html: contentHTML, // html body
  };

  // send mail with defined transport object
  let info = await transporter.sendMail(mailOptions);
  logIt(
    "Message sent from:%s to:%s subject: %s, id: %s",
    from,
    to,
    subject,
    info.messageId
  );
}

function logIt(log) {
  console.log(log);
  var dt = new Date();
  log_file.write(util.format(dt + " ----- " + log) + "\n");
}

// const activationMail = (token) => {
//     return (
//         '<!doctype html> <html> <head> <meta name="viewport" content="width=device-width" /> <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> <title>Simple Transactional Email</title> <style> /* ------------------------------------- GLOBAL RESETS ------------------------------------- */ /*All the styling goes here*/ img { border: none; -ms-interpolation-mode: bicubic; max-width: 50%; } body { background-color: #f6f6f6; font-family: sans-serif; -webkit-font-smoothing: antialiased; font-size: 14px; line-height: 1.4; margin: 0; padding: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; } table { border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; } table td { font-family: sans-serif; font-size: 14px; vertical-align: top; } /* ------------------------------------- BODY & CONTAINER ------------------------------------- */ .body { background-color: #f6f6f6; width: 100%; } /* Set a max-width, and make it display as block so it will automatically stretch to that width, but will also shrink down on a phone or something */ .container { display: block; margin: 0 auto !important; /* makes it centered */ max-width: 580px; padding: 10px; width: 580px; } /* This should also be a block element, so that it will fill 100% of the .container */ .content { box-sizing: border-box; display: block; margin: 0 auto; max-width: 580px; padding: 10px; } /* ------------------------------------- HEADER, FOOTER, MAIN ------------------------------------- */ .main { background: #ffffff; border-radius: 3px; width: 100%; } .wrapper { box-sizing: border-box; padding: 20px; } .content-block { padding-bottom: 10px; padding-top: 10px; } .footer { clear: both; margin-top: 10px; text-align: center; width: 100%; } .footer td, .footer p, .footer span, .footer a { color: #999999; font-size: 12px; text-align: center; } /* ------------------------------------- TYPOGRAPHY ------------------------------------- */ h1, h2, h3, h4 { color: #000000; font-family: sans-serif; font-weight: 400; line-height: 1.4; margin: 0; margin-bottom: 30px; } h1 { font-size: 35px; font-weight: 300; text-align: center; text-transform: capitalize; } p, ul, ol { font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px; } p li, ul li, ol li { list-style-position: inside; margin-left: 5px; } a { color: #3498db; text-decoration: underline; } /* ------------------------------------- BUTTONS ------------------------------------- */ .btn { box-sizing: border-box; width: 100%; } .btn > tbody > tr > td { padding-bottom: 15px; } .btn table { width: auto; } .btn table td { background-color: #ffffff; border-radius: 5px; text-align: center; } .btn a { background-color: #ffffff; border: solid 1px #3498db; border-radius: 5px; box-sizing: border-box; color: #3498db; cursor: pointer; display: inline-block; font-size: 14px; font-weight: bold; margin: 0; padding: 12px 25px; text-decoration: none; text-transform: capitalize; } .btn-primary table td { background-color: #3498db; } .btn-primary a { background-color: #3498db; border-color: #3498db; color: #ffffff; } /* ------------------------------------- OTHER STYLES THAT MIGHT BE USEFUL ------------------------------------- */ .last { margin-bottom: 0; } .first { margin-top: 0; } .align-center { text-align: center; } .align-right { text-align: right; } .align-left { text-align: left; } .clear { clear: both; } .mt0 { margin-top: 0; } .mb0 { margin-bottom: 0; } .preheader { color: transparent; display: none; height: 0; max-height: 0; max-width: 0; opacity: 0; overflow: hidden; mso-hide: all; visibility: hidden; width: 0; } .powered-by a { text-decoration: none; } hr { border: 0; border-bottom: 1px solid #f6f6f6; margin: 20px 0; } /* ------------------------------------- RESPONSIVE AND MOBILE FRIENDLY STYLES ------------------------------------- */ @media only screen and (max-width: 620px) { table[class=body] h1 { font-size: 28px !important; margin-bottom: 10px !important; } table[class=body] p, table[class=body] ul, table[class=body] ol, table[class=body] td, table[class=body] span, table[class=body] a { font-size: 16px !important; } table[class=body] .wrapper, table[class=body] .article { padding: 10px !important; } table[class=body] .content { padding: 0 !important; } table[class=body] .container { padding: 0 !important; width: 100% !important; } table[class=body] .main { border-left-width: 0 !important; border-radius: 0 !important; border-right-width: 0 !important; } table[class=body] .btn table { width: 100% !important; } table[class=body] .btn a { width: 100% !important; } table[class=body] .img-responsive { height: auto !important; max-width: 100% !important; width: auto !important; } } /* ------------------------------------- PRESERVE THESE STYLES IN THE HEAD ------------------------------------- */ @media all { .ExternalClass { width: 100%; } .ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div { line-height: 100%; } .apple-link a { color: inherit !important; font-family: inherit !important; font-size: inherit !important; font-weight: inherit !important; line-height: inherit !important; text-decoration: none !important; } #MessageViewBody a { color: inherit; text-decoration: none; font-size: inherit; font-family: inherit; font-weight: inherit; line-height: inherit; } .btn-primary table td:hover { background-color: #34495e !important; } .btn-primary a:hover { background-color: #34495e !important; border-color: #34495e !important; } } </style> </head> <body class=""> <table role="presentation" border="0" cellpadding="0" cellspacing="0" class="body"> <tr> <td>&nbsp;</td> <td class="container"> <div class="content"> <!-- START CENTERED WHITE CONTAINER --><img src="http://statik.wiki.com.tr/assets/alaev/img/alaevlogo.jpg" style="align-content: center; flex: auto; display: block; margin-left: auto; margin-right: auto; width: 50%;"/> <table role="presentation" class="main"> <!-- START MAIN CONTENT AREA --> <tr> <td class="wrapper"> <table role="presentation" border="0" cellpadding="0" cellspacing="0"> <tr> <td> <p>Merhaba,</p> <p>Email adresini onaylamak ve aktive etmek için lütfen butona tıklayınız.</p> <table role="presentation" border="0" cellpadding="0" cellspacing="0" class="btn btn-primary"> <tbody> <tr> <td align="left"> <table role="presentation" border="0" cellpadding="0" cellspacing="0"> <tbody> <tr> <td> <a href="yonetim.alaev.org.tr/email-dogrulama/' +
//         token +
//         '" target="_blank">Emailinizi aktive edin!</a> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> <p>Bu mailin size ait olmadığını düşünüyorsanız linke tıklamayınız.</p> </td> </tr> </table> </td> </tr> <!-- END MAIN CONTENT AREA --> </table> <!-- END CENTERED WHITE CONTAINER --> <!-- START FOOTER --> <div class="footer"> <table role="presentation" border="0" cellpadding="0" cellspacing="0"> <tr> <td class="content-block"> </td> </tr> <tr> <td class="content-block powered-by"> Powered by <a href="https://alaev.org.tr/">ALAEV</a>. </td> </tr> </table> </div> <!-- END FOOTER --> </div> </td> <td>&nbsp;</td> </tr> </table> </body> </html>'
//     );
// };
// const forgotPasswordMail = (token) => {
//     return (
//         '<!doctype html> <html> <head> <meta name="viewport" content="width=device-width" /> <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> <title>Simple Transactional Email</title> <style> /* ------------------------------------- GLOBAL RESETS ------------------------------------- */ /*All the styling goes here*/ img { border: none; -ms-interpolation-mode: bicubic; max-width: 50%; } body { background-color: #f6f6f6; font-family: sans-serif; -webkit-font-smoothing: antialiased; font-size: 14px; line-height: 1.4; margin: 0; padding: 0; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; } table { border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; } table td { font-family: sans-serif; font-size: 14px; vertical-align: top; } /* ------------------------------------- BODY & CONTAINER ------------------------------------- */ .body { background-color: #f6f6f6; width: 100%; } /* Set a max-width, and make it display as block so it will automatically stretch to that width, but will also shrink down on a phone or something */ .container { display: block; margin: 0 auto !important; /* makes it centered */ max-width: 580px; padding: 10px; width: 580px; } /* This should also be a block element, so that it will fill 100% of the .container */ .content { box-sizing: border-box; display: block; margin: 0 auto; max-width: 580px; padding: 10px; } /* ------------------------------------- HEADER, FOOTER, MAIN ------------------------------------- */ .main { background: #ffffff; border-radius: 3px; width: 100%; } .wrapper { box-sizing: border-box; padding: 20px; } .content-block { padding-bottom: 10px; padding-top: 10px; } .footer { clear: both; margin-top: 10px; text-align: center; width: 100%; } .footer td, .footer p, .footer span, .footer a { color: #999999; font-size: 12px; text-align: center; } /* ------------------------------------- TYPOGRAPHY ------------------------------------- */ h1, h2, h3, h4 { color: #000000; font-family: sans-serif; font-weight: 400; line-height: 1.4; margin: 0; margin-bottom: 30px; } h1 { font-size: 35px; font-weight: 300; text-align: center; text-transform: capitalize; } p, ul, ol { font-family: sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 15px; } p li, ul li, ol li { list-style-position: inside; margin-left: 5px; } a { color: #3498db; text-decoration: underline; } /* ------------------------------------- BUTTONS ------------------------------------- */ .btn { box-sizing: border-box; width: 100%; } .btn > tbody > tr > td { padding-bottom: 15px; } .btn table { width: auto; } .btn table td { background-color: #ffffff; border-radius: 5px; text-align: center; } .btn a { background-color: #ffffff; border: solid 1px #3498db; border-radius: 5px; box-sizing: border-box; color: #3498db; cursor: pointer; display: inline-block; font-size: 14px; font-weight: bold; margin: 0; padding: 12px 25px; text-decoration: none; text-transform: capitalize; } .btn-primary table td { background-color: #3498db; } .btn-primary a { background-color: #3498db; border-color: #3498db; color: #ffffff; } /* ------------------------------------- OTHER STYLES THAT MIGHT BE USEFUL ------------------------------------- */ .last { margin-bottom: 0; } .first { margin-top: 0; } .align-center { text-align: center; } .align-right { text-align: right; } .align-left { text-align: left; } .clear { clear: both; } .mt0 { margin-top: 0; } .mb0 { margin-bottom: 0; } .preheader { color: transparent; display: none; height: 0; max-height: 0; max-width: 0; opacity: 0; overflow: hidden; mso-hide: all; visibility: hidden; width: 0; } .powered-by a { text-decoration: none; } hr { border: 0; border-bottom: 1px solid #f6f6f6; margin: 20px 0; } /* ------------------------------------- RESPONSIVE AND MOBILE FRIENDLY STYLES ------------------------------------- */ @media only screen and (max-width: 620px) { table[class=body] h1 { font-size: 28px !important; margin-bottom: 10px !important; } table[class=body] p, table[class=body] ul, table[class=body] ol, table[class=body] td, table[class=body] span, table[class=body] a { font-size: 16px !important; } table[class=body] .wrapper, table[class=body] .article { padding: 10px !important; } table[class=body] .content { padding: 0 !important; } table[class=body] .container { padding: 0 !important; width: 100% !important; } table[class=body] .main { border-left-width: 0 !important; border-radius: 0 !important; border-right-width: 0 !important; } table[class=body] .btn table { width: 100% !important; } table[class=body] .btn a { width: 100% !important; } table[class=body] .img-responsive { height: auto !important; max-width: 100% !important; width: auto !important; } } /* ------------------------------------- PRESERVE THESE STYLES IN THE HEAD ------------------------------------- */ @media all { .ExternalClass { width: 100%; } .ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div { line-height: 100%; } .apple-link a { color: inherit !important; font-family: inherit !important; font-size: inherit !important; font-weight: inherit !important; line-height: inherit !important; text-decoration: none !important; } #MessageViewBody a { color: inherit; text-decoration: none; font-size: inherit; font-family: inherit; font-weight: inherit; line-height: inherit; } .btn-primary table td:hover { background-color: #34495e !important; } .btn-primary a:hover { background-color: #34495e !important; border-color: #34495e !important; } } </style> </head> <body class=""> <table role="presentation" border="0" cellpadding="0" cellspacing="0" class="body"> <tr> <td>&nbsp;</td> <td class="container"> <div class="content"> <!-- START CENTERED WHITE CONTAINER --><img src="http://statik.wiki.com.tr/assets/alaev/img/alaevlogo.jpg" style="align-content: center; flex: auto; display: block; margin-left: auto; margin-right: auto; width: 50%;"/> <table role="presentation" class="main"> <!-- START MAIN CONTENT AREA --> <tr> <td class="wrapper"> <table role="presentation" border="0" cellpadding="0" cellspacing="0"> <tr> <td> <p>Merhaba,</p> <p>Şifrenizi değiştirmek için lütfen butona tıklayınız.</p> <table role="presentation" border="0" cellpadding="0" cellspacing="0" class="btn btn-primary"> <tbody> <tr> <td align="left"> <table role="presentation" border="0" cellpadding="0" cellspacing="0"> <tbody> <tr> <td> <a href="yonetim.alaev.org.tr/sifremi-unuttum/' +
//         token +
//         '" target="_blank">Şifrenizi Değiştirin!</a> </td> </tr> </tbody> </table> </td> </tr> </tbody> </table> <p>Bu mailin size ait olmadığını düşünüyorsanız linke tıklamayınız.</p> </td> </tr> </table> </td> </tr> <!-- END MAIN CONTENT AREA --> </table> <!-- END CENTERED WHITE CONTAINER --> <!-- START FOOTER --> <div class="footer"> <table role="presentation" border="0" cellpadding="0" cellspacing="0"> <tr> <td class="content-block"> </td> </tr> <tr> <td class="content-block powered-by"> Powered by <a href="https://alaev.org.tr/">ALAEV</a>. </td> </tr> </table> </div> <!-- END FOOTER --> </div> </td> <td>&nbsp;</td> </tr> </table> </body> </html>'
//     );
// };
