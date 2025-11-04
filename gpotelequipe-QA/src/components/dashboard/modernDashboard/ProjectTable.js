import React from 'react';
import { Input, Table } from 'reactstrap';
import DashCard from '../dashboardCards/DashCard';

const tableData = [
  {
    category: 'Demanda GI',
    quantity: 6428,
    status: 'Rev. Demanda',
    items: [],
  },
  {
    category: 'ASP CRD',
    quantity: 6411,
    status: 'Em andamento',
    items: [17],
  },
  {
    category: 'ASP SUP',
    quantity: 6411,
    status: 'Em andamento',
    items: [],
  },
  {
    category: 'Entrega',
    quantity: 6324,
    status: 'Em andamento',
    items: [87],
  },
  {
    category: 'Instalação',
    quantity: 6274,
    status: 'Em andamento',
    items: [50],
  },
  {
    category: 'Val. Instalação',
    quantity: 6253,
    status: 'Em andamento',
    items: [21],
  },
  {
    category: 'Integração',
    quantity: 6211,
    status: 'Em andamento',
    items: [42],
  },
  {
    category: 'Qualidade',
    quantity: 6085,
    status: 'Em andamento',
    items: [126],
  },
  {
    category: 'Não Aceitos',
    quantity: 274,
    status: '',
    items: [],
  },
  {
    category: 'Aceito',
    quantity: 5811,
    status: '',
    items: [],
  },
];

const InformationTable = () => {
  return (
    <DashCard
      title="Quadro de Informações"
      subtitle="Status Atual"
      actions={
        <Input type="select" className="form-select">
          <option value="0">Ano 2019</option>
          <option value="1">Ano 2020</option>
          <option value="2">Ano 2022</option>
        </Input>
      }
    >
      <div className="table-responsive">
        <Table className="text-nowrap mt-3 mb-0 align-middle custom-table" borderless>
          <thead style={{ backgroundColor: 'white' }}>
            <tr style={{ backgroundColor: 'white' }}>
              <th style={{ backgroundColor: 'white' }}>Categoria</th>
              <th style={{ backgroundColor: 'white' }}>Quantidade</th>
              <th style={{ backgroundColor: 'white' }}>Status</th>
              <th style={{ backgroundColor: 'white' }}>Itens</th>
            </tr>
          </thead>
          <tbody style={{ backgroundColor: 'white' }}>
            {tableData.map((tdata) => (
              <tr key={tdata.category} className="border-top">
                <td style={{ backgroundColor: 'white' }}>{tdata.category}</td>
                <td style={{ backgroundColor: 'white' }}>{tdata.quantity}</td>
                <td style={{ backgroundColor: 'white' }}>{tdata.status}</td>
                <td style={{ backgroundColor: 'white' }}>
                  {tdata.items.length > 0 ? tdata.items.join(', ') : '-'}
                </td>
              </tr>
            ))}
          </tbody>
        </Table>
      </div>
    </DashCard>
  );
};

export default InformationTable;
