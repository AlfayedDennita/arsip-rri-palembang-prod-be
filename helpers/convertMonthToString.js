function convertMonthToString(monthKey, simple = false) {
  const fullNameMonths = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  const simpleMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agt',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  if (simple) {
    return simpleMonths[monthKey];
  } else {
    return fullNameMonths[monthKey];
  }
}

module.exports = convertMonthToString;
