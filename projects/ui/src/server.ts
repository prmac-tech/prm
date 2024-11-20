import * as express from 'express';
import * as dotenv  from 'dotenv';
import * as path from 'path';
import * as nunjucks from 'nunjucks'
import {indexController} from './controllers/indexController';
//dotenv.config({path: __dirname + '/.env'})
const app = express();
const port = process.env.PORT || 3000;

//import dotenv from 'dotenv';
dotenv.config();

app.get('/', indexController);

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});

app.set('views', path.join(__dirname, '/views'));

const nunjuckLoader = new nunjucks.FileSystemLoader(app.get('views'));

const nunjuckLoaderOptions = {
  watch: process.env.NUNJUCKS_LOADER_WATCH === 'true',
  noCache: process.env.NUNJUCKS_LOADER_NO_CACHE === 'true',
};

const nunjucksEnvironment = new nunjucks.Environment(
  nunjuckLoader,
  nunjuckLoaderOptions
);

nunjucksEnvironment.express(app);

app.set('view engine', 'njk');
