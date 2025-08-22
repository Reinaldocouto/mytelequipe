import {
  Document,
  Packer,
  WidthType,
  Paragraph,
  Table,
  TableCell,
  TableRow,
  TextRun,
  Footer,
  BorderStyle,
  AlignmentType,
  Header,
  TabStopType,
  ImageRun,
} from 'docx';
import { saveAs } from 'file-saver';
import autoTable from 'jspdf-autotable';
import { jsPDF as JsPDF } from 'jspdf';
import api from './api';
import telequipeImg from '../assets/images/logos/logotelequipe.png';
import telefonicaImg from '../assets/images/logos/logo_telefonica.png';

function formatarDataHoje() {
  const hoje = new Date();
  const dia = hoje.getDate().toString().padStart(2, '0');
  const mes = hoje.toLocaleString('pt-BR', { month: 'long' });
  const ano = hoje.getFullYear();
  return `Guarulhos - SP, ${dia} de ${mes} de ${ano}`;
}
async function getNameFile(selected) {
  try {
    const duasLetras = selected[0]?.t2descricaocod?.split('-')[0] ?? 'XX';
    const response = await api.post('v1/projetotelefonica/gerartaf', {
      regional: duasLetras,
      idpmts: selected[0]?.idpmts,
      idobra: selected[0]?.idobra,
      idcliente: localStorage.getItem('sessionCodidcliente'),
      idusuario: localStorage.getItem('sessionId'),
      idloja: localStorage.getItem('sessionloja'),
      ...selected[0],
    });
    return response.data.numeroTAF;
  } catch (error) {
    if (error.response) {
      // Erro retornado pelo servidor
      alert(`Erro ao gerar TAF: ${error.response.data.erro || error.response.statusText}`);
      throw new Error('Error ao gerar TAF');
    } else {
      // Erro de rede ou outro erro
      alert('Erro ao conectar com o servidor');
      throw new Error('Error ao gerar TAF');
    }
  }
}

const gerarDocxT4 = async (selected, telequipeBuffer, telefonicaBuffer) => {
  const tableHeader = new TableRow({
    children: [
      'ID VIVO',
      'Sigla',
      'PEP Serviço Survey',
      'PEP Serviço Implantação',
      'PO Serviço Survey',
      'PO Serviço Implantação',
      'Vistoria - REAL',
      'On Air (Ativação) REAL',
    ].map(
      (header) =>
        new TableCell({
          children: [
            new Paragraph({
              alignment: AlignmentType.LEFT,
              children: [
                new TextRun({
                  text: header,
                  bold: true,
                  color: 'FFFFFF',
                  size: 16, // Fonte 8
                }),
              ],
            }),
          ],
          shading: { fill: '595959' },
          borders: {
            top: { style: BorderStyle.SINGLE, size: 1 },
            bottom: { style: BorderStyle.SINGLE, size: 1 },
            left: { style: BorderStyle.SINGLE, size: 1 },
            right: { style: BorderStyle.SINGLE, size: 1 },
          },
        }),
    ),
  });
  const tableBody = selected.map((item) => {
    const rowData = [
      item.idobra || '',
      item.site || '',
      item.t2codmatservsw || '',
      item.t4codeqmatswserv || '',
      item.po || '',
      '',
      item.atividade === 'Vistoria' ? '26/06/2025' : '',
      item.atividade === 'Ativação' ? '26/06/2025' : '',
    ];

    return new TableRow({
      children: rowData.map(
        (val) =>
          new TableCell({
            children: [
              new Paragraph({
                alignment: AlignmentType.LEFT,
                children: [
                  new TextRun({
                    text: String(val),
                    size: 16, // Fonte 8 igual ao header
                  }),
                ],
              }),
            ],
            shading: { fill: 'D9D9D9' },
            borders: {
              top: { style: BorderStyle.SINGLE, size: 1 },
              bottom: { style: BorderStyle.SINGLE, size: 1 },
              left: { style: BorderStyle.SINGLE, size: 1 },
              right: { style: BorderStyle.SINGLE, size: 1 },
            },
          }),
      ),
    });
  });

  const rodapeAssinatura = new Table({
    width: { size: 100, type: 'pct' },
    rows: [
      new TableRow({
        children: [
          new Paragraph({
            children: [],
            spacing: { after: 80 },
          }),
          new TableCell({
            borders: {
              top: { style: BorderStyle.SINGLE, size: 12, color: '000000' },
              bottom: { style: BorderStyle.NONE, size: 6, color: '000000' },
              left: { style: BorderStyle.NONE, size: 6, color: '000000' },
              right: { style: BorderStyle.NONE, size: 6, color: '000000' },
            },
            children: [
              new Paragraph({
                children: [new TextRun({ text: 'Anna Platero', bold: true })],
              }),
              new Paragraph({ text: 'Diretora de Implantação' }),
              new Paragraph({ text: 'Telequipe Projetos e Telecomunicações LTDA.' }),
              new Paragraph({ text: 'anna.christina@telequipeprojetos.com.br' }),
            ],
          }),
          new TableCell({
            width: { size: 10, type: WidthType.PERCENTAGE },
            borders: {
              top: { style: BorderStyle.NONE, size: 12, color: '000000' },
              bottom: { style: BorderStyle.NONE, size: 12, color: '000000' },
              left: { style: BorderStyle.NONE, size: 12, color: '000000' },
              right: { style: BorderStyle.NONE, size: 12, color: '000000' },
            },
            children: [new Paragraph({})],
          }),
          new Paragraph({
            children: [],
            spacing: { after: 80 },
          }),

          new TableCell({
            borders: {
              top: { style: BorderStyle.SINGLE, size: 12, color: '000000' },
              bottom: { style: BorderStyle.NONE, size: 6, color: '000000' },
              left: { style: BorderStyle.NONE, size: 6, color: '000000' },
              right: { style: BorderStyle.NONE, size: 6, color: '000000' },
            },
            children: [
              new Paragraph({
                children: [new TextRun({ text: 'Ruan Carlos Cardoso Sales', bold: true })],
              }),
              new Paragraph({ text: 'Gerente Implantação Regional BA/SE' }),
              new Paragraph({ text: 'Telefônica Brasil' }),
              new Paragraph({ text: 'ruan.sales@telefonica.com' }),
            ],
          }),
        ],
      }),
    ],
  });

  const header = new Header({
    children: [
      new Paragraph({
        tabStops: [
          { type: TabStopType.LEFT, position: 0 },
          { type: TabStopType.CENTER, position: 4500 },
          { type: TabStopType.RIGHT, position: 9000 },
        ],
        children: [
          new ImageRun({
            data: telequipeBuffer,
            transformation: { width: 120, height: 40 },
          }),
          new TextRun({ text: '\tTERMO DE ACEITAÇÃO\t', bold: true, size: 36 }),
          new ImageRun({
            data: telefonicaBuffer,
            transformation: { width: 140, height: 40 },
          }),
        ],
      }),
    ],
  });

  const doc = new Document({
    sections: [
      {
        headers: {
          default: header,
        },
        children: [
          new Paragraph({
            children: [],
            spacing: { after: 300 },
            alignment: AlignmentType.LEFT,
          }),
          new Paragraph({
            children: [new TextRun({ text: formatarDataHoje(), bold: true })],
            spacing: { after: 200 },
            alignment: AlignmentType.LEFT,
          }),
          new Paragraph({
            children: [
              new TextRun({ text: 'Termo de Aceitação: TAF_RAN_NE_2025_0260', bold: true }),
            ],
            spacing: { after: 300 },
            alignment: AlignmentType.LEFT,
          }),
          new Paragraph({
            text: 'Este documento estabelece a Aceitação Final das obras listadas abaixo referente ao fornecimento de equipamentos, software e serviços conforme escopo contratado.',
            spacing: { after: 300 },
            alignment: AlignmentType.JUSTIFIED,
          }),
          new Paragraph({
            children: [
              new TextRun({ text: 'Projeto: ', bold: true }),
              new TextRun({ text: 'VIVO RAN SIRIUS' }),
            ],
            bullet: { level: 0 },
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({ text: 'Contrato: ', bold: true }),
              new TextRun({ text: selected?.numerodocontrato ?? 'N/A' }),
            ],
            bullet: { level: 0 },
            spacing: { after: 100 },
          }),
          new Paragraph({
            children: [
              new TextRun({ text: 'Regionais: ', bold: true }),
              new TextRun({ text: selected?.regional ?? 'N/A' }),
            ],
            bullet: { level: 0 },
            spacing: { after: 300 },
          }),
          new Paragraph({
            children: [
              new TextRun({ text: 'Contratada: ', bold: true }),
              new TextRun({
                text: `Telequipe Projetos e Telecomunicações LTDA – CódForn ${
                  selected?.codfornecedor ?? 'N/A'
                }`,
              }),
            ],
            spacing: { after: 300 },
          }),
          // Tabela
          new Table({
            rows: [tableHeader, ...tableBody],
            width: { size: 100, type: 'pct' },
          }),
          new Paragraph({ text: '\n\n', spacing: { after: 6100 } }),
          rodapeAssinatura,
        ],
        footers: {
          default: new Footer({
            children: [
              new Paragraph({
                children: [
                  new TextRun({
                    text: '*** Este documento está classificado como USO INTERNO por TELEFÔNICA.',
                    size: 16,
                  }),
                ],
                spacing: { before: 200 },
                alignment: AlignmentType.LEFT,
              }),
              new Paragraph({
                children: [
                  new TextRun({
                    text: '*** This document is classified as INTERNAL USE BY TELEFÔNICA.',
                    size: 16,
                  }),
                ],
                spacing: { before: 200 },
                alignment: AlignmentType.LEFT,
              }),
            ],
          }),
        },
      },
    ],
  });

  const numeroTAF = await getNameFile(selected);
  Packer.toBlob(doc).then((blob) => {
    saveAs(blob, `${numeroTAF.replace(/_/g, '-')}.docx`);
  });
};
async function gerarPDFT4(selected) {
  if (!selected || !Array.isArray(selected) || selected.length === 0) {
    console.error('Lista "selected" está vazia ou inválida.');
    return;
  }

  const doc = new JsPDF();
  const pageWidth = doc.internal.pageSize.getWidth();

  // Cabeçalho com logos e título
  doc.addImage(telequipeImg, 'PNG', 10, 10, 40, 20);
  doc.addImage(telefonicaImg, 'PNG', pageWidth - 50, 10, 40, 20);

  doc.setFontSize(18);
  doc.setFont(undefined, 'bold');
  doc.text('TERMO DE ACEITAÇÃO', pageWidth / 2, 25, { align: 'center' });

  let y = 40;

  const hoje = new Date();
  const dataTexto = `Guarulhos - SP, ${hoje
    .getDate()
    .toString()
    .padStart(2, '0')} de ${hoje.toLocaleString('pt-BR', {
    month: 'long',
  })} de ${hoje.getFullYear()}`;

  doc.setFontSize(11);
  doc.setFont(undefined, 'bold');
  doc.text(dataTexto, 10, y);
  y += 10;

  doc.setFont(undefined, 'bold');
  doc.text('Termo de Aceitação: TAF_RAN_NE_2025_0260', 10, y);
  y += 10;

  doc.setFont(undefined, 'normal');
  doc.text(
    'Este documento estabelece a Aceitação Final das obras listadas abaixo referente ao fornecimento de equipamentos, software e serviços conforme escopo contratado.',
    10,
    y,
    { maxWidth: pageWidth - 20, align: 'justify' },
  );
  y += 15;

  const lista = [
    { label: 'Projeto:', value: selected[0]?.projeto || 'VIVO RAN SIRIUS' },
    { label: 'Contrato:', value: selected[0]?.numerodocontrato || 'N/A' },
    { label: 'Regionais:', value: selected[0]?.regional || 'N/A' },
  ];

  lista.forEach(({ label, value }) => {
    doc.setFont(undefined, 'bold');
    doc.text(`• ${label}`, 10, y);
    const labelWidth = doc.getTextWidth(`• ${label} `);
    doc.setFont(undefined, 'normal');
    doc.text(value, 10 + labelWidth, y);
    y += 8;
  });

  y += 2;

  doc.setFont(undefined, 'bold');
  doc.text('Contratada:', 10, y);
  const contratadaText = ` Telequipe Projetos e Telecomunicações LTDA – CódForn ${
    selected[0]?.codfornecedor ?? 'N/A'
  }`;
  const textWidth = doc.getTextWidth('Contratada:');
  doc.setFont(undefined, 'normal');
  doc.text(contratadaText, 10 + textWidth + 2, y);
  y += 6;

  autoTable(doc, {
    startY: y,
    head: [
      [
        'ID VIVO',
        'Sigla',
        'PEP Serviço Survey',
        'PEP Serviço Implantação',
        'PO Serviço Survey',
        'PO Serviço Implantação',
        'Vistoria - REAL',
        'On Air (Ativação) REAL',
      ],
    ],
    body: selected.map((item) => [
      item.idobra || '',
      item.site || '',
      item.t2codmatservsw || '',
      item.t4codeqmatswserv || '',
      item.po || '',
      '',
      item.atividade === 'Vistoria' ? '26/06/2025' : '',
      item.atividade === 'Ativação' ? '26/06/2025' : '',
    ]),
    styles: {
      fontSize: 8,
      cellPadding: 2,
      lineWidth: 0.3,
      lineColor: [0, 0, 0],
    },
    headStyles: {
      fillColor: [89, 89, 89],
      textColor: 255,
      fontStyle: 'bold',
    },
    bodyStyles: {
      fillColor: [217, 217, 217],
    },
  });

  y = doc.lastAutoTable.finalY + 20;

  // Assinaturas
  const assinaturaY = y + 50;
  doc.line(10, assinaturaY, pageWidth / 2 - 5, assinaturaY);
  doc.line(pageWidth / 2 + 5, assinaturaY, pageWidth - 10, assinaturaY);

  doc.setFontSize(10);
  doc.setFont(undefined, 'bold');
  doc.text('Anna Platero', 10, assinaturaY + 5);
  doc.text('Ruan Carlos Cardoso Sales', pageWidth / 2 + 10, assinaturaY + 5);

  doc.setFont(undefined, 'normal');
  doc.text('Diretora de Implantação', 10, assinaturaY + 10);
  doc.text('Gerente Implantação Regional BA/SE', pageWidth / 2 + 10, assinaturaY + 10);
  doc.text('Telequipe Projetos e Telecomunicações LTDA.', 10, assinaturaY + 15);
  doc.text('Telefônica Brasil', pageWidth / 2 + 10, assinaturaY + 15);
  doc.text('anna.christina@telequipeprojetos.com.br', 10, assinaturaY + 20);
  doc.text('ruan.sales@telefonica.com', pageWidth / 2 + 10, assinaturaY + 20);

  // Rodapé
  doc.setFontSize(8);
  doc.setTextColor(100);
  const footerY = doc.internal.pageSize.getHeight() - 15;
  doc.text('*** Este documento está classificado como USO INTERNO por TELEFÔNICA.', 10, footerY);
  doc.text('*** This document is classified as INTERNAL USE BY TELEFÔNICA.', 10, footerY + 5);

  // Nome do arquivo (com base na regional)
  const numeroTAF = await getNameFile(selected);
  const fileName = `${numeroTAF.replace(/_/g, '-')}.pdf`;

  // Salvar o PDF
  doc.save(fileName);
}

export { gerarDocxT4, gerarPDFT4 };
