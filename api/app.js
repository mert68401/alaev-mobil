var request = require("request");
var httpPort = 2000;
const express = require("express");
const jwt = require("jsonwebtoken");
const bodyParser = require("body-parser");
const mongoClient = require("mongodb").MongoClient;
var url = "mongodb+srv://devAccount:NzJECdw6qyT534CZ@cluster0.8khb6.mongodb.net/alaev?retryWrites=true&w=majority";
var database = null;
const nodemailer = require("nodemailer");
const fs = require("fs");
const util = require("util");
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
app.use(
    bodyParser.urlencoded({
        extended: true,
    })
);
app.use(bodyParser.json());
app.use(function (req, res, next) {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS, PUT, PATCH, DELETE");
    res.setHeader("Access-Control-Allow-Headers", "X-Requested-With,Authorization,Content-Type,Nano-Token");
    res.setHeader("Access-Control-Allow-Credentials", true);
    next();
});

var http = require("http").createServer(app);

app.get("/", function (req, res) {
    res.status(404).send("Not Found"); //write a response to the client
    res.end(); //end the response
});
var router = express.Router();

router.post("/register", function (req, res) {
    const body = req.body;
    console.log(body);
    var userObj;
    if (body.email.length > 0 && body.fullName.length > 0 && body.password.length > 0 && body.role.length > 0) {
        userObj = {
            _id: makeid(),
            email: {
                str: body.email,
                verified: false,
            },
            fullName: body.fullName,
            password: body.password,
            role: body.role,
            createdAt: new Date(),
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

    database.collection("userAccounts").insertOne(userObj, function (err, result) {
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
                    message: "User not found!",
                });
                return false;
            }
            jwt.sign({ _id: doc._id, email: doc.email.str }, "mERoo36mM?", function (err, token) {
                if (err) {
                    res.status(401).send({
                        succes: false,
                        message: "Some error has occured!",
                    });
                }
                res.json({ token });
            });
            return;
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
//Get getCompanySupplies
*/
router.post("/getCompanySupplies", function (req, res) {
    var body = req.body;
    var filter = body.filter;
    var params = body.params;
    var projection = params.projection ? { projection: params.projection } : {};
    var data = database.collection("companySupplies").find(filter, projection);
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
//Get getCompanySupply
*/
router.post("/getCompanySupply", function (req, res) {
    var body = req.body;
    var filter = body.filter;
    database
        .collection("companySupplies")
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

router.post("/getProductsByCategoryAlias", isAuthenticated, function (req, res) {
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
});

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
router.post("/getSolutionsByCategoryAlias", isAuthenticated, function (req, res) {
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
});

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
                .find(Object.assign(filter, { title: { $regex: keyword, $options: "i" } }))
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
            if (collInfos.find((x) => x.name == collection && x.type == "collection")) {
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
                    sendEmail(docs.smtpServer, docs.smtpPort, docs.mailUserName, docs.mailPassword, params.from, params.to, params.name, params.subject, params.contentText, params.contentHTML)
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
            if (docs && docs.mailUserName && docs.mailPassword && docs.smtpServer && docs.smtpPort && params.from && params.to && params.subject && params.contentText && params.contentHTML) {
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
                    sendEmail(docs.smtpServer, docs.smtpPort, docs.mailUserName, docs.mailPassword, params.from, params.to, "", params.subject, params.contentText, params.contentHTML)
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
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for (var i = 0; i < 17; i++) text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;
}
async function sendEmail(host, port, user, pass, from, to, name, subject, contentText, contentHTML) {
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
    logIt("Message sent from:%s to:%s subject: %s, id: %s", from, to, subject, info.messageId);
}

function logIt(log) {
    console.log(log);
    var dt = new Date();
    log_file.write(util.format(dt + " ----- " + log) + "\n");
}