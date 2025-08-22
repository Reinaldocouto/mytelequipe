import { useState, useEffect, useMemo } from 'react';
import { Button, Modal, ModalBody, ModalHeader, ModalFooter, Form, Input } from 'reactstrap';
import PropTypes from 'prop-types';
import VisibilityIcon from '@mui/icons-material/Visibility';
import VisibilityOffIcon from '@mui/icons-material/VisibilityOff';
import Switch from '@mui/material/Switch';

const LOCAL_STORAGE_KEY = 'userFieldVisibility';

const ConfiguracaoCamposVisiveis = ({ isOpen, toggle, fieldVisibility, setFieldVisibility }) => {
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    const savedVisibility = localStorage.getItem(LOCAL_STORAGE_KEY);
    if (savedVisibility) {
      setFieldVisibility(JSON.parse(savedVisibility));
    }
  }, [setFieldVisibility]);

  // Filtra os campos com base no texto da busca
  const filteredFields = useMemo(() => {
    const normalizedSearch = searchTerm.toLowerCase().trim().replace(/\s+/g, '');
    return Object.keys(fieldVisibility).filter((fieldName) =>
      fieldName.toLowerCase().includes(normalizedSearch),
    );
  }, [fieldVisibility, searchTerm]);

  const saveToLocalStorage = () => {
    localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(fieldVisibility));
    toggle();
  };

  const showAllFields = () => {
    const updatedVisibility = { ...fieldVisibility };
    filteredFields.forEach((key) => {
      updatedVisibility[key] = true;
    });
    setFieldVisibility(updatedVisibility);
  };

  const hideAllFields = () => {
    const updatedVisibility = { ...fieldVisibility };
    filteredFields.forEach((key) => {
      updatedVisibility[key] = false;
    });
    setFieldVisibility(updatedVisibility);
  };

  const toggleFieldVisibility = (fieldName) => {
    setFieldVisibility((prev) => ({
      ...prev,
      [fieldName]: !prev[fieldName],
    }));
  };

  return (
    <Modal
      isOpen={isOpen}
      toggle={toggle}
      className="modal-dialog modal-md"
      backdrop="static"
      keyboard={false}
      size="md"
    >
      <div className="modal-content bg-white rounded-4 shadow-sm">
        <ModalHeader toggle={toggle} className="border-bottom bg-white">
          <span className="fw-bold">Configuração de Campos Visíveis</span>
        </ModalHeader>

        <ModalBody className="px-4 py-3 bg-white" style={{ maxHeight: '60vh', overflowY: 'auto' }}>
          <Input
            type="text"
            placeholder="Buscar campo..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="mb-3"
          />
          <Form>
            {filteredFields.length > 0 ? (
              filteredFields.map((fieldName) => (
                <div
                  key={fieldName}
                  className="d-flex align-items-center justify-content-between border-bottom py-2"
                >
                  <span className="fw-normal">
                    {fieldName.replace(/([A-Z])/g, ' $1').replace(/^./, (str) => str.toUpperCase())}
                  </span>
                  <Switch
                    checked={fieldVisibility[fieldName]}
                    onChange={() => toggleFieldVisibility(fieldName)}
                    color="primary"
                  />
                </div>
              ))
            ) : (
              <div className="text-muted">Nenhum campo encontrado.</div>
            )}
          </Form>
        </ModalBody>

        <ModalFooter className="d-flex justify-content-between">
          <div>
            <Button color="secondary" outline size="sm" className="me-2" onClick={showAllFields}>
              <VisibilityIcon fontSize="small" className="me-1" />
              Mostrar Todos
            </Button>
            <Button color="secondary" outline size="sm" onClick={hideAllFields}>
              <VisibilityOffIcon fontSize="small" className="me-1" />
              Ocultar Todos
            </Button>
          </div>
          <Button color="primary" onClick={saveToLocalStorage}>
            Salvar Configuração
          </Button>
        </ModalFooter>
      </div>
    </Modal>
  );
};

ConfiguracaoCamposVisiveis.propTypes = {
  isOpen: PropTypes.bool.isRequired,
  toggle: PropTypes.func.isRequired,
  fieldVisibility: PropTypes.object.isRequired,
  setFieldVisibility: PropTypes.func.isRequired,
};

export default ConfiguracaoCamposVisiveis;
