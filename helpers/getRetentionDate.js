function getRetentionDate(date, category) {
  console.log(date);
  const dateYear = date.getFullYear();
  const dateMonth = date.getMonth();
  const dateDate = date.getDate();
  const dateHours = date.getHours();
  const dateMinutes = date.getMinutes();
  const dateSeconds = date.getSeconds();

  let yearOffset = null;

  if (category === 'important') {
    yearOffset = 25;
  } else if (category === 'useful') {
    yearOffset = 10;
  } else if (category === 'temporary') {
    yearOffset = 2;
  }

  return new Date(
    dateYear + yearOffset,
    dateMonth,
    dateDate,
    dateHours,
    dateMinutes,
    dateSeconds
  );
}

module.exports = getRetentionDate;
