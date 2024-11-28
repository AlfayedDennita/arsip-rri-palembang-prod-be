require('dotenv').config();

const express = require('express');
const cors = require('cors');
const chalk = require('chalk');
const cron = require('node-cron');

const db = require('./models');
const initDBEntities = require('./helpers/initDBEntities');

const removeExpiredArchives = require('./jobs/removeExpiredArchives');

const app = express();
const port = process.env.PORT || 8081;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const corsOptions = {
  origin: '*',
  credentials: true,
  optionSuccessStatus: 200,
};

app.use(cors(corsOptions));

app.use('/static', express.static('public'));

app.use(require('./middlewares/checkAPIKey'));
app.use(require('./middlewares/checkScopesInit'));

app.use('/auth', require('./routers/auth'));

app.use(require('./middlewares/checkAuth'));

app.use('/scopes', require('./routers/scopes'));
app.use('/users', require('./routers/users'));
app.use('/archive-codes', require('./routers/archiveCodes'));
app.use('/archives', require('./routers/archives'));
app.use('/reports', require('./routers/reports'));
app.use('/stats', require('./routers/stats'));
app.use('/me', require('./routers/me'));

app.use(require('./middlewares/handleError'));

if (process.argv.includes('--listen')) {
  cron.schedule('0 * * * * ', removeExpiredArchives);

  (async () => {
    try {
      await db.sequelize.authenticate();
      console.log(
        chalk.green('Database connection has been established successfully.')
      );

      if (process.argv.includes('--force-db')) {
        await db.sequelize.sync({ force: true });
      } else if (process.argv.includes('--alter-db')) {
        await db.sequelize.sync({ alter: true });
      } else {
        await db.sequelize.sync();
      }

      console.log(
        chalk.blue('All database models has been synchronized successfully.')
      );

      await initDBEntities();

      app.listen(port, () => {
        console.log(chalk.green.bold(`Server is listening on port ${port}!`));
      });
    } catch (error) {
      console.error('Unable to connect to the database:', error);
    }
  })();
}

module.exports = app;
