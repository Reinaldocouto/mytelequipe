export default function createLocalDate(dateValue) {
  if (!dateValue) return null;

  // Sentinelas do Excel (evitar datas inválidas)
  if (dateValue === '1899-12-30' || dateValue === '1899-12-29') {
    return null;
  }

  // Se já é Date, retorna
  if (dateValue instanceof Date) {
    return Number.isNaN(dateValue.getTime()) ? null : dateValue;
  }
  if (typeof dateValue === 'number') {
    const d = new Date(dateValue);
    return Number.isNaN(d.getTime()) ? null : d;
  }
  if (typeof dateValue === 'string') {
    const s = dateValue.trim();

    // Apenas data: YYYY-MM-DD → cria data local (sem shift de timezone)
    const mDateOnly = s.match(/^(\d{4})-(\d{2})-(\d{2})$/);
    if (mDateOnly) {
      const y = parseInt(mDateOnly[1], 10);
      const m = parseInt(mDateOnly[2], 10) - 1;
      const d = parseInt(mDateOnly[3], 10);
      return new Date(y, m, d);
    }

    // Data/hora sem timezone: YYYY-MM-DD HH:mm[:ss] → cria data/hora local
    const mDateTimeLocal = s.match(/^(\d{4})-(\d{2})-(\d{2})[ T](\d{2}):(\d{2})(?::(\d{2}))?$/);
    if (mDateTimeLocal && !/[zZ]|[+\\-]\d{2}:?\d{2}$/.test(s)) {
      const y = parseInt(mDateTimeLocal[1], 10);
      const m = parseInt(mDateTimeLocal[2], 10) - 1;
      const d = parseInt(mDateTimeLocal[3], 10);
      const hh = parseInt(mDateTimeLocal[4], 10);
      const mm = parseInt(mDateTimeLocal[5], 10);
      const ss = mDateTimeLocal[6] ? parseInt(mDateTimeLocal[6], 10) : 0;
      return new Date(y, m, d, hh, mm, ss);
    }

    // ISO com timezone (ex.: ...Z ou +03:00) → usa parser padrão
    const dIso = new Date(s);
    return Number.isNaN(dIso.getTime()) ? null : dIso;
  }

  // Fallback
  try {
    const d = new Date(dateValue);
    return Number.isNaN(d.getTime()) ? null : d;
  } catch {
    return null;
  }
}

// Helper de formatação para exibição/Excel em pt-BR
export function formatDatePtBR(value) {
  const d = createLocalDate(value);
  return d ? d.toLocaleDateString('pt-BR') : '';
}
