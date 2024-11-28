const bcrypt = require('bcrypt');

const db = require('../models');

async function initRootScope() {
  const rootScope = await db.scopes.create({
    name: 'RRI Palembang',
    level: 0,
    ancestorId: null,
  });

  return rootScope;
}

async function initRootUser(rootScopeId) {
  await db.users.create({
    username: 'root',
    email: 'root@root.root',
    password: await bcrypt.hash('root1234', 10),
    role: 'root',
    name: 'Root',
    ScopeId: rootScopeId,
  });
}

async function initDBEntities() {
  let rootScope = await db.scopes.findOne({ where: { ancestorId: null } });

  if (!rootScope) {
    rootScope = await initRootScope();
  }

  const rootUser = await db.users.findOne({ where: { username: 'root' } });

  if (!rootUser) {
    await initRootUser(rootScope.id);
  }
}

module.exports = initDBEntities;
