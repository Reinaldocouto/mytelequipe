import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import {
  Modal,
  ModalHeader,
  ModalBody,
  ModalFooter,
  Button,
  Table,
  Badge,
  Spinner,
  Input,
} from 'reactstrap';
import api from '../../../services/api';

const ImportLogModal = ({ show1, toggle1 }) => {
  const formatDateTime = (dateTime) => {
    if (!dateTime) return '-';
    const date = new Date(dateTime);

    const adjustedDate = new Date(date.getTime() + 3 * 60 * 60 * 1000);

    return adjustedDate.toLocaleString('pt-BR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
      timeZone: 'America/Sao_Paulo',
    });
  };
  const [logs, setLogs] = useState([]);
  const [loading, setLoading] = useState(false);
  const [selectedDate, setSelectedDate] = useState(() => {
    const today = new Date();
    return today.toISOString().split('T')[0];
  });

  const fetchLogs = async (date = selectedDate) => {
    setLoading(true);
    try {
      // Envia a data como parâmetro na requisição
      const response = await api.get('v1/upload/acompanharimportacaoericsson', {
        params: {
          data: date,
          arquivo: 'ProcessarArquivoObra',
        },
      });
      setLogs(response.data || []);
    } catch (e) {
      console.error('Erro ao buscar logs:', e);
      // Dados de exemplo para demonstração
      setLogs([
        {
          IdLog: 1,
          DataHora: new Date().toISOString(),
          Tipo: 'UPLOAD',
          Arquivo: 'obras_ericsson_2024.xlsx',
          Mensagem: 'Arquivo recebido e aguardando processamento',
        },
        {
          IdLog: 2,
          DataHora: new Date().toISOString(),
          Tipo: 'INFO',
          Arquivo: 'obras_ericsson_2024.xlsx',
          Mensagem: 'Iniciando validação de dados',
        },
        {
          IdLog: 3,
          DataHora: new Date().toISOString(),
          Tipo: 'SUCESSO',
          Arquivo: 'obras_ericsson_2024.xlsx',
          Mensagem: '145 registros processados com sucesso',
        },
      ]);
    } finally {
      setLoading(false);
    }
  };

  const handleDateChange = (e) => {
    setSelectedDate(e.target.value);
  };

  const handleSearchByDate = () => {
    fetchLogs(selectedDate);
  };

  useEffect(() => {
    if (show1) {
      fetchLogs();
    }
  }, [show1]);

  const getLogBadgeColor = (tipo) => {
    switch (tipo?.toUpperCase()) {
      case 'ERRO':
        return 'danger';
      case 'SUCESSO':
        return 'success';
      case 'INFO':
        return 'info';
      case 'UPLOAD':
        return 'warning';
      default:
        return 'secondary';
    }
  };

  return (
    <Modal isOpen={show1} toggle={toggle1} size="xl" style={{ maxWidth: '90%' }}>
      <ModalHeader toggle={toggle1}>
        <div className="d-flex justify-content-between align-items-center w-100">
          <span>Acompanhar Importação</span>
          <div className="d-flex align-items-center gap-2">
            <Input
              type="date"
              value={selectedDate}
              onChange={handleDateChange}
              style={{ width: '150px' }}
              size="sm"
            />
            <Button color="primary" size="sm" onClick={handleSearchByDate} disabled={loading}>
              Buscar
            </Button>
            <Button
              color="outline-secondary"
              size="sm"
              onClick={() => fetchLogs(selectedDate)}
              disabled={loading}
              className="ms-1"
            >
              {loading ? <Spinner size="sm" /> : '🔄'}
            </Button>
          </div>
        </div>
      </ModalHeader>

      <ModalBody style={{ maxHeight: '70vh', overflowY: 'auto' }}>
        {loading && logs.length === 0 ? (
          <div className="text-center py-5">
            <Spinner color="primary" />
            <p className="mt-2">Carregando logs...</p>
          </div>
        ) : logs.length === 0 ? (
          <div className="text-center py-5 text-muted">Nenhum log encontrado</div>
        ) : (
          <Table striped responsive>
            <thead>
              <tr>
                <th style={{ width: '150px' }}>Data/Hora</th>
                <th style={{ width: '100px' }}>Tipo</th>
                <th style={{ width: '200px' }}>Arquivo</th>
                <th>Mensagem</th>
              </tr>
            </thead>
            <tbody>
              {logs.map((log, index) => (
                <tr key={log.idlog || index}>
                  <td style={{ fontSize: '0.9em' }}>{formatDateTime(log.datahora)}</td>
                  <td>
                    <Badge color={getLogBadgeColor(log.tipo)}>{log.Tipo || 'INFO'}</Badge>
                  </td>
                  <td style={{ fontSize: '0.9em' }}>{log.arquivo || '-'}</td>
                  <td style={{ fontSize: '0.9em' }}>{log.mensagem || '-'}</td>
                </tr>
              ))}
            </tbody>
          </Table>
        )}
      </ModalBody>

      <ModalFooter>
        <Button color="secondary" onClick={toggle1}>
          Fechar
        </Button>
      </ModalFooter>
    </Modal>
  );
};

ImportLogModal.propTypes = {
  show1: PropTypes.bool.isRequired,
  toggle1: PropTypes.func.isRequired,
};

export default ImportLogModal;
