import * as FileSaver from 'file-saver';
import * as XLSX from 'sheetjs-style';

const exportExcelHawei = ({ excelData, fileName }) => {
  if (!excelData || excelData.length === 0) return;

  const fileType =
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=UTF-8';
  const fileExtension = '.xlsx';

  const valFor = (row, keys) => {
    const k = keys.find((kk) => row[kk] !== undefined && row[kk] !== null && row[kk] !== '');
    return k ? row[k] : undefined;
  };
  const num = (v) => (v == null || v === '' ? 0 : Number(v));

  const isTotalmenteCancelado = (row) => {
    const rq = num(valFor(row, ['REQUESTED QTY', 'RequestedQty', 'requestedQty', 'REQUESTED_QTY']));
    const qc = num(valFor(row, ['QUANTITY CANCEL', 'QuantityCancel', 'quantityCancel', 'QUANTITY_CANCEL']));
    return rq > 0 && qc === rq;
  };


  const isSiteNovo = (row) => {
    // 🔧 Define getFromPaths local (igual ao do front)
    const getFromPaths = (obj, paths) => {
      if (!Array.isArray(paths)) return undefined;
      const values = paths.map((p) =>
        p.split('.').reduce((acc, k) => (acc && acc[k] !== undefined ? acc[k] : undefined), obj)
      );
      return values.find((val) => val !== undefined && val !== null);
    };

    // 🔧 Define fisicoPaths (mesmo padrão do front)
    const fisicoPaths = {
      fisicoCriadoEm: [
        'fisicoCriadoEm',
        'fisico_criado_em',
        'fisico.criadoEm',
        'fisico.criado_em',
        'acompanhamentoFisico.criadoEm',
        'acompanhamentoFisico.criado_em',
        'fisicocriadoem'
      ],
      fisicoAtualizadoEm: [
        'fisicoAtualizadoEm',
        'fisico_atualizado_em',
        'fisico.atualizadoEm',
        'fisico.atualizado_em',
        'acompanhamentoFisico.atualizadoEm',
        'acompanhamentoFisico.atualizado_em',
        'fisicoatualizadoem'
      ],
    };

    const pick = (val) => {
      if (!val) return null;
      const s = typeof val === 'string' ? val.trim() : val;
      const iso = typeof s === 'string' && s.includes(' ') && !s.includes('T') ? s.replace(' ', 'T') : s;
      const d = new Date(iso);
      return Number.isNaN(d.getTime()) ? null : d;
    };

    const vCriado =
      getFromPaths(row, fisicoPaths.fisicoCriadoEm) ??
      row['FÍSICO • CRIADO EM'] ??
      row.criadoEm ?? row.criado_em ?? row.createdAt ?? row.created_at;

    const vAtualizado =
      getFromPaths(row, fisicoPaths.fisicoAtualizadoEm) ??
      row['FÍSICO • ATUALIZADO EM'] ??
      row['ÚLTIMA ATUALIZAÇÃO'] ??
      row.ultimaAtualizacao ?? row.ultima_atualizacao ?? row.updatedAt ?? row.updated_at;

    console.log('🔍 ROW', row);
    console.log('→ vCriado:', vCriado, '| vAtualizado:', vAtualizado);

    const criado = pick(vCriado);
    const atualizado = pick(vAtualizado);

    console.log('→ criado parsed:', criado, '| atualizado parsed:', atualizado);

    if (!criado) {
      console.log('⛔ Nenhum valor de criação encontrado, retornando false');
      return false;
    }

    const diffDias = (Date.now() - criado.getTime()) / 86400000;
    const datasIguaisOuSemAtualizacao = !atualizado || atualizado.getTime() === criado.getTime();
    const resultado = diffDias <= 7 && datasIguaisOuSemAtualizacao;

    console.log(
      '📅 diffDias:',
      diffDias.toFixed(2),
      '| datasIguaisOuSemAtualizacao:',
      datasIguaisOuSemAtualizacao,
      '| RESULTADO:',
      resultado
    );

    return resultado;
  };



  const autoFitAndColor = (rows) => {
    const ws = XLSX.utils.json_to_sheet(rows);
    const headerCols = Object.keys(rows[0] || {});

    ws['!cols'] = headerCols.map((col) => {
      const maxLen = rows.reduce(
        (m, r) => Math.max(m, (r[col] ?? '').toString().length),
        col.length
      );
      return { wch: Math.min(Math.max(maxLen + 2, 8), 60) };
    });

    const EXTRA_COLS = 20;
    const totalColsToPaint = Math.max(headerCols.length + EXTRA_COLS, 40);
    ws['!ref'] = `A1:${XLSX.utils.encode_cell({ r: rows.length, c: totalColsToPaint - 1 })}`;

    rows.forEach((row, rIdx) => {
      let fill = 'FFFFFFFF';
      if (isTotalmenteCancelado(row)) fill = 'FFFFCDD2';
      else if (isSiteNovo(row)) fill = 'FFC8E6C9';

      for (let cIdx = 0; cIdx < totalColsToPaint; cIdx++) {
        const addr = XLSX.utils.encode_cell({ r: rIdx + 1, c: cIdx });
        if (!ws[addr]) ws[addr] = { t: 's', v: '' };
        ws[addr].s = { fill: { patternType: 'solid', fgColor: { rgb: fill } } };
      }
    });

    return ws;
  };

  const ws = autoFitAndColor(excelData);
  const wb = { Sheets: { data: ws }, SheetNames: ['data'] };
  const excelBuffer = XLSX.write(wb, { bookType: 'xlsx', type: 'array' });
  const blob = new Blob([excelBuffer], { type: fileType });
  FileSaver.saveAs(blob, fileName + fileExtension);
};

export default exportExcelHawei;
