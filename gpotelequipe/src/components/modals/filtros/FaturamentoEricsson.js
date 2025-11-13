import { Modal, ModalHeader, Button, ModalBody, ModalFooter } from 'reactstrap';
import PropTypes from 'prop-types';
import { memo, useState, useCallback, useMemo } from 'react';

const camposFiltro = {
  apartirododiadatacriacaopo: { type: 'date', label: 'A partir do dia da criação do PO' },
  siteid: { type: 'text' },
  po: { type: 'text' },
  poritem: { type: 'text' },
  datacriacaopo: { type: 'date' },
  id: { type: 'text' },
  descricaoservico: { type: 'text' },
  datamigo: { type: 'date' },
  nmigo: { type: 'text' },
  qtdmigo: { type: 'text' },
  datamiro: { type: 'date' },
  nmiro: { type: 'text' },
  qtdmiro: { type: 'text' },
  codigocliente: { type: 'text' },
  estado: {
    type: 'select',
    options: ['SP', 'MG', 'BA', 'SE', 'DF', 'RJ'],
  },
  cidade: { type: 'text' },
  qtyordered: { type: 'text' },
  medidafiltro: { type: 'text' },
  medidafiltrounitario: { type: 'text' },
  classificacaopo: { type: 'text' },
  mos: { type: 'date' },
  instalacao: { type: 'date' },
  integracao: { type: 'date' },
  aceitacao: { type: 'date' },
  doc: { type: 'date' },
  aprovacaoDocs: { type: 'text' },
  analise: { type: 'select', options: ['OK', 'NOK'] },
  fat: {
    type: 'select',
    options: [
      'Aguarda Aceitação',
      'Em Andamento',
      'Emitir NF',
      'Solicitado Faturamento',
      'Doc. Aguarda Análise',
      'Aguarda TX',
      '100% Faturado',
      'OK',
      'NOK',
    ],
  },
  valorafaturar: { type: 'text' },
};

// ==================== Linha do Filtro Otimizada ====================
const FiltroLinha = memo(
  ({ campo, value, onChange, type, options, label }) => {
    const handleChange = useCallback(
      (e) => {
        onChange(campo, e.target.value);
      },
      [campo, onChange],
    );

    // Função para formatar label automático, caso não exista no config
    const formatLabel = useCallback((fieldName) => {
      return fieldName
        .toUpperCase()
        .replace(/_/g, ' ')
        .replace(/([A-Z])/g, ' $1')
        .trim();
    }, []);

    return (
      <div className="d-flex align-items-center gap-2 border-bottom pb-2">
        <label htmlFor={campo} style={{ minWidth: '400px', margin: 0 }}>
          {label || formatLabel(campo)}
        </label>
        {type === 'select' ? (
          <select id={campo} value={value} onChange={handleChange} className="form-control">
            <option value="">Selecione</option>
            {options.map((opt) => (
              <option key={opt} value={opt}>
                {opt}
              </option>
            ))}
          </select>
        ) : type === 'date' ? (
          <input
            id={campo}
            type="date"
            value={value}
            onChange={handleChange}
            className="form-control"
          />
        ) : (
          <input
            id={campo}
            type="text"
            value={value}
            onChange={handleChange}
            className="form-control"
          />
        )}
      </div>
    );
  },
  (prevProps, nextProps) =>
    prevProps.value === nextProps.value && prevProps.type === nextProps.type,
);

FiltroLinha.propTypes = {
  campo: PropTypes.string.isRequired,
  value: PropTypes.string.isRequired,
  onChange: PropTypes.func.isRequired,
  type: PropTypes.string.isRequired,
  options: PropTypes.array,
  label: PropTypes.string,
};

// ==================== Componente Modal Otimizado ====================
const FaturamentoEricsson = ({ showFiltro, filtro, toggleFiltro, filtrar }) => {
  // Calcula data de 30 dias atrás no formato yyyy-mm-dd
  const defaultDate = useMemo(() => {
    const d = new Date();
    d.setDate(d.getDate() - 30);
    return d.toISOString().split('T')[0];
  }, []);

  const initialState = useMemo(
    () =>
      Object.keys(camposFiltro).reduce((acc, key) => {
        acc[key] = key === 'apartirododiadatacriacaopo' ? defaultDate : '';
        return acc;
      }, {}),
    [defaultDate],
  );

  const [filtroState, setFiltroState] = useState({ ...initialState, ...filtro });

  const handleChange = useCallback((field, value) => {
    setFiltroState((prev) => ({ ...prev, [field]: value }));
  }, []);

  const handleApply = useCallback(() => {
    filtrar(filtroState);
  }, [filtrar, filtroState]);

  const limparFiltros = useCallback(() => {
    setFiltroState(initialState);
  }, [initialState]);

  return (
    <Modal
      isOpen={showFiltro}
      toggle={toggleFiltro}
      className="modal-dialog modal-xl modal-dialog-scrollable"
      backdrop="static"
      keyboard={false}
    >
      <ModalHeader toggle={toggleFiltro}>
        Filtro Completo
        <Button
          color="link"
          onClick={limparFiltros}
          className="float-end"
          style={{ fontSize: '0.8rem', padding: '0' }}
        >
          <i className="fas fa-eraser me-1"></i>Limpar Tudo
        </Button>
      </ModalHeader>
      <ModalBody>
        <div className="d-flex flex-column gap-3">
          {Object.entries(camposFiltro).map(([campo, config]) => (
            <FiltroLinha
              key={campo}
              campo={campo}
              value={filtroState[campo]}
              onChange={handleChange}
              type={config.type}
              options={config.options || []}
              label={config.label}
            />
          ))}
        </div>
      </ModalBody>
      <ModalFooter className="d-flex justify-content-between">
        <Button color="outline-danger" onClick={limparFiltros}>
          <i className="fas fa-eraser me-2"></i>Limpar Filtros
        </Button>
        <div>
          <Button color="secondary" onClick={toggleFiltro} className="me-2">
            Cancelar
          </Button>
          <Button color="primary" onClick={handleApply}>
            Aplicar Filtro
          </Button>
        </div>
      </ModalFooter>
    </Modal>
  );
};

FaturamentoEricsson.propTypes = {
  showFiltro: PropTypes.bool.isRequired,
  toggleFiltro: PropTypes.func.isRequired,
  filtro: PropTypes.object.isRequired,
  filtrar: PropTypes.func.isRequired,
};

export default memo(FaturamentoEricsson);
