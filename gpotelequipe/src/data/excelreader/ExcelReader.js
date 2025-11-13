// eslint-disable-next-line import/no-extraneous-dependencies
import ExcelJS from 'exceljs';

// Função para ler um arquivo Excel
const excelReader = async (file) => {
  const workbook = new ExcelJS.Workbook();
  const reader = new FileReader();
  const keywords = ['data', 'reativacao', 'inativacao', 'primhabilitacao','dataemissao','datavalidadecnh','datacadastro','reset9','dataadmissao', 'datademissao', 'datanascimento'];
  // Retorna uma Promise que será resolvida com os dados do Excel
  return new Promise((resolve, reject) => {
    reader.onload = async (event) => {
      try {
        const data = event.target.result;
        await workbook.xlsx.load(data); // Carrega o arquivo Excel no Workbook

        // Pega a primeira planilha do arquivo
        const worksheet = workbook.worksheets[0];
        const jsonData = [];

        // Itera sobre cada linha e coleta os valores
        const headers = worksheet.getRow(1).values.slice(1); // O método `.values` inclui um valor vazio no índice 0, então usamos `.slice(1)` para removê-lo.
        try {
          // Itera sobre as linhas a partir da segunda (ignorando os cabeçalhos)
          worksheet.eachRow((row, rowNumber) => {
            if (rowNumber > 1) {
              // Começa a partir da segunda linha
              const rowData = {};

              headers.forEach((header, index) => {
                const titleHeader = header
                  .toLowerCase()
                  .normalize('NFD')
                  .replace(/[\u0300-\u036f]/g, '')
                  .replace(/[^a-z0-9]/g, '')
                  .trim();

                let value = row.values[index + 1] ?? null;
                value = typeof value === 'object' ? value?.result : value;
                const hasKeyword = keywords.some((keyword) => titleHeader.includes(keyword));

                if (hasKeyword) {
                  const regex = /^\d{2}\/\d{2}\/\d{4}$/;
                  if (!regex.test(value)) {
                    rowData[titleHeader] = value;
                  } else {
                    const [day, month, year] = value.toString().split('/'); // Separar os componentes da data
                    const date =  `${day}/${month}/${year}`;//new Date(`${year}-${month}-${day}`); //
                    rowData[titleHeader] = date;
                  }
                } else if (titleHeader === 'idpessoa' || titleHeader === 'idtreinamento') {
                  rowData[titleHeader] =
                    value !== null && typeof value === 'object' ? value.result : Number(value) ?? 0;
                } else {
                  rowData[titleHeader] = value;
                }
              });
              jsonData.push(rowData);
            }
          });
        } catch (error) {
          console.log(error);
        } finally {
          resolve(jsonData);
        }
      } catch (error) {
        reject(error); // Caso ocorra erro, rejeita a Promise
      }
    };

    // Lê o arquivo como ArrayBuffer
    reader.readAsArrayBuffer(file);
  });
};

export default excelReader;
