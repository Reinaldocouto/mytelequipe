import * as FileSaver from 'file-saver';
import XLSX from 'sheetjs-style';

const exportExcel = ({ excelData, fileName }) => {
  const fileType =
    'application/vnd.openxmloformats-officedocument.spreadsheetml.sheet;charset-UTF-8';
  const fileExtension = '.xlsx';

  // Função para ajustar a largura das colunas com base no conteúdo
  const autoFitColumns = (jsonData) => {
    const worksheet = XLSX.utils.json_to_sheet(jsonData);
    const columns = Object.keys(jsonData[0]);

    const colWidths = columns.map((col) => {
      const maxLength = jsonData.reduce(
        (max, row) => Math.max(max, row[col] ? row[col].toString().length : 0),
        col.length,
      );
      return { wch: maxLength + 2 }; // +2 para um pouco de espaço extra
    });

    worksheet['!cols'] = colWidths;

    if (
      Array.isArray(jsonData) &&
      jsonData.length > 0 &&
      jsonData.some((row) => 'acionamentovivodeletado' in row)
    ) {
      jsonData.forEach((row, rowIndex) => {
        if (row.acionamentovivodeletado === 'SIM') {
          columns.forEach((col, colIndex) => {
            const cellAddress = XLSX.utils.encode_cell({ r: rowIndex + 1, c: colIndex });
            const cell = worksheet[cellAddress];

            if (cell) {
              cell.s = {
                fill: { patternType: 'solid', fgColor: { rgb: 'FFB71C1C' } },
                font: { color: { rgb: 'FFFFFFFF' }, bold: true },
              };
            }
          });
        }
      });
    }

    return worksheet;
  };

  const ws = autoFitColumns(excelData);
  const wb = { Sheets: { data: ws }, SheetNames: ['data'] };
  const excelBuffer = XLSX.write(wb, { bookType: 'xlsx', type: 'array' });
  const data = new Blob([excelBuffer], { type: fileType });
  FileSaver.saveAs(data, fileName + fileExtension);
};
export default exportExcel;
