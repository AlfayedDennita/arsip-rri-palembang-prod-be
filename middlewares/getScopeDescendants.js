const db = require('../models');

function flattenScopes(scopes) {
  const flattenedScopes = [];

  for (const scope of scopes) {
    const { descendants, ...scopeData } = scope.toJSON();

    flattenedScopes.push(scopeData);

    if (scope?.descendants?.length > 0) {
      flattenedScopes.push(...flattenScopes(scope.descendants));
    }
  }

  return flattenedScopes;
}

async function getScopeDescendants(req, res, next) {
  const scopes = await db.scopes.findAll({
    where: {
      id: req.user.ScopeId,
    },
    include: [
      {
        model: db.scopes,
        as: 'descendants',
        include: [
          {
            model: db.scopes,
            as: 'descendants',
            include: [
              {
                model: db.scopes,
                as: 'descendants',
                include: [
                  {
                    model: db.scopes,
                    as: 'descendants',
                    include: [
                      {
                        model: db.users,
                      },
                      {
                        model: db.archiveCodes,
                      },
                      {
                        model: db.reports,
                      },
                    ],
                  },
                  {
                    model: db.users,
                  },
                  {
                    model: db.archiveCodes,
                  },
                  {
                    model: db.reports,
                  },
                ],
              },
              {
                model: db.users,
              },
              {
                model: db.archiveCodes,
              },
              {
                model: db.reports,
              },
            ],
          },
          {
            model: db.users,
          },
          {
            model: db.archiveCodes,
          },
          {
            model: db.reports,
          },
        ],
      },
      {
        model: db.users,
      },
      {
        model: db.archiveCodes,
      },
      {
        model: db.reports,
      },
    ],
  });

  const [scopeWithDescendants] = scopes;
  req.scopeWithDescendants = scopeWithDescendants;
  req.visibleScopes = flattenScopes(scopes);
  req.visibleScopeIds = req.visibleScopes.map((scope) => scope.id);

  return next();
}

module.exports = getScopeDescendants;
