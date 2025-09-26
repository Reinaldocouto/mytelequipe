export default function createLocalDate(dateValue) {
  if (!dateValue) return null;
  if (dateValue === '1899-12-30') {
    console.log('HER');
    console.log(dateValue);
    return null;
  }
  try {
    // Se já contém 'T', usa como está
    if (dateValue.includes('T')) {
      return new Date(dateValue);
    }

    // Para datas no formato YYYY-MM-DD, cria data local
    const [year, month, day] = dateValue.split('-');
    if (year && month && day) {
      // Cria data local (mês é 0-indexado no JavaScript)
      return new Date(parseInt(year, 10), parseInt(month, 10) - 1, parseInt(day, 10));
    }

    // Fallback para outros formatos
    return new Date(dateValue);
  } catch (error) {
    console.warn('Erro ao processar data:', dateValue, error);
    return null;
  }
}
