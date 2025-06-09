import React, { useState } from 'react';
import { Table } from 'reactstrap';
import PropTypes from 'prop-types';

const EnhancedTable = ({ data }) => {
  const [selectedItems, setSelectedItems] = useState({});

  // Função para verificar se todos os itens de uma categoria estão selecionados
  const allChildrenSelected = (clientId) => {
    const categories = data[clientId].categories.map((category) => category.id);
    return categories.every((categoryId) => selectedItems[categoryId]);
  };

  // Função para alternar a seleção de um cliente e suas categorias
  const toggleSelection = (clientId, categoryId) => {
    const newSelectedItems = { ...selectedItems };

    // Se clicou no cliente (pai)
    if (!categoryId) {
      const allSelected = allChildrenSelected(clientId);
      data[clientId].categories.forEach((category) => {
        newSelectedItems[category.id] = !allSelected;
      });
      newSelectedItems[clientId] = !allSelected;
    } else {
      // Se clicou em uma categoria (filho)
      newSelectedItems[categoryId] = !selectedItems[categoryId];
      // Verifica se todos os filhos estão selecionados para selecionar o pai
      const allSelected = data[clientId].categories.every(
        (category) => newSelectedItems[category.id],
      );
      newSelectedItems[clientId] = allSelected;
    }

    setSelectedItems(newSelectedItems);
  };

  // Função para renderizar os dados da tabela
  const renderTableRows = () => {
    return Object.entries(data).map(([clientId, client]) => (
      <React.Fragment key={clientId}>
        {/* Cliente */}
        <tr>
          <th scope="row" onClick={() => toggleSelection(clientId)}>
            <input type="checkbox" checked={selectedItems[clientId]} onChange={() => {}} />{' '}
            {clientId}
          </th>
          <td>{client.clientData.emitido}</td>
          <td>{client.clientData.semMIGO}</td>
          <td>{client.clientData.comMIGO}</td>
          <td>{client.clientData.faturar}</td>          
          <td>{client.clientData.percentMIGO}</td>
        </tr>

        {/* Subcategorias */}
       {/* {client.categories.map((category) => (
          <tr key={category.id} className="child-row">
            <th scope="row">
              <input
                type="checkbox"
                checked={selectedItems[category.id]}
                onChange={() => toggleSelection(clientId, category.id)}
              />{' '}
              {category.name}
            </th>
            <td>{category.emitido}</td>
            <td>{category.semMIGO}</td>
            <td>{category.comMIGO}</td>
            <td>{category.faturar}</td>            
            <td>{category.percentMIGO}</td>
          </tr>
        ))} */}
      </React.Fragment>
    ));
  };

  return (
    <Table bordered className="table-light mr-6" style={{ width: '100%' }}>
      <thead>
        <tr>
          <th>Cliente</th>
          <th>Emitido</th>
          <th>SemMIGO</th>
          <th>COM MIGO</th>
          <th>A Faturar</th>          
          <th>% MIGO</th>
        </tr>
      </thead>
      <tbody>{renderTableRows()}</tbody>
    </Table>
  );
};

EnhancedTable.propTypes = {
  data: PropTypes.object.isRequired, // Validando que 'data' é um objeto requerido
};

export default EnhancedTable;
