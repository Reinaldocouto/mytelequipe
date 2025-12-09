import { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import {
  Modal,
  ModalHeader,
  ModalBody,
  ModalFooter,
  Button,
  Input,
  Label,
  FormGroup,
} from 'reactstrap';
import api from '../../services/api';

export function CrqModalComponent({ isOpen, onClose, onSubmit, initialData }) {
  const [form, setForm] = useState({
    id: '',
    descricao: '',
    impacto: 'Total',
    numeroCrq: '',
    dataInicio: '',
    dataFim: '',
    status: 'Solicitada',
    tipo: 'CRQ',
  });

  const formatDateForInput = (value) => {
    if (!value) return '';
    if (value.includes('T')) return value.substring(0, 10);
    return value.split(' ')[0];
  };

  useEffect(() => {
    if (initialData) {
      setForm((prev) => ({
        ...prev,
        id: initialData?.id ?? '',
        descricao: initialData?.descricao ?? '',
        impacto: initialData?.impacto ?? 'Total',
        numeroCrq: initialData?.numero ?? '',
        dataInicio: formatDateForInput(initialData?.dataInicio ?? ''),
        dataFim: formatDateForInput(initialData?.dataFim ?? ''),
        status: initialData?.status ?? 'Solicitada',
        tipo: initialData?.tipo ?? 'CRQ',
      }));
    }
  }, [initialData]);

  const impactoOptions = ['Total', 'Parcial'];
  const statusOptions = ['Aprovada', 'Cancelada', 'Fechada', 'Pedir', 'Rejeitada', 'Solicitada'];
  const tipoOptions = ['Impacto', 'Instalação', 'CRQ'];

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((f) => ({ ...f, [name]: value }));
  };

  const handleSubmit = () => {
    onSubmit?.(form);
    onClose?.();
  };

  return (
    <Modal isOpen={isOpen} toggle={onClose} size="xl">
      <ModalHeader toggle={onClose}>CRQ</ModalHeader>
      <ModalBody>
        <div className="container-fluid">
          <div className="row">
            <div className="col-md-6">
              <FormGroup>
                <Label for="descricao">descricao</Label>
                <Input
                  id="descricao"
                  name="descricao"
                  type="text"
                  value={form.descricao}
                  onChange={handleChange}
                  placeholder="Descreva a descricao"
                />
              </FormGroup>
            </div>
            <div className="col-md-3">
              <FormGroup>
                <Label for="impacto">Impacto</Label>
                <Input
                  id="impacto"
                  name="impacto"
                  type="select"
                  value={form.impacto}
                  onChange={handleChange}
                >
                  {impactoOptions.map((opt) => (
                    <option key={opt} value={opt}>
                      {opt}
                    </option>
                  ))}
                </Input>
              </FormGroup>
            </div>
            <div className="col-md-3">
              <FormGroup>
                <Label for="numeroCrq">Nº CRQ</Label>
                <Input
                  id="numeroCrq"
                  name="numeroCrq"
                  type="text"
                  value={form.numeroCrq}
                  onChange={handleChange}
                  placeholder="Número do CRQ"
                />
              </FormGroup>
            </div>
          </div>

          <div className="row">
            <div className="col-md-3">
              <FormGroup>
                <Label for="dataInicio">Início CRQ</Label>
                <Input
                  id="dataInicio"
                  name="dataInicio"
                  type="date"
                  value={form.dataInicio}
                  onChange={handleChange}
                />
              </FormGroup>
            </div>
            <div className="col-md-3">
              <FormGroup>
                <Label for="dataFim">Final CRQ</Label>
                <Input
                  id="dataFim"
                  name="dataFim"
                  type="date"
                  value={form.dataFim}
                  onChange={handleChange}
                />
              </FormGroup>
            </div>
            <div className="col-md-3">
              <FormGroup>
                <Label for="status">status</Label>
                <Input
                  id="status"
                  name="status"
                  type="select"
                  value={form.status}
                  onChange={handleChange}
                >
                  {statusOptions.map((opt) => (
                    <option key={opt} value={opt}>
                      {opt}
                    </option>
                  ))}
                </Input>
              </FormGroup>
            </div>
            <div className="col-md-3">
              <FormGroup>
                <Label for="tipo">Tipo CRQ</Label>
                <Input
                  id="tipo"
                  name="tipo"
                  type="select"
                  value={form.tipo}
                  onChange={handleChange}
                >
                  {tipoOptions.map((opt) => (
                    <option key={opt} value={opt}>
                      {opt}
                    </option>
                  ))}
                </Input>
              </FormGroup>
            </div>
          </div>
        </div>
      </ModalBody>
      <ModalFooter className="d-flex justify-content-end">
        <Button color="primary" onClick={handleSubmit}>
          Salvar CRQ
        </Button>
        <Button color="secondary" onClick={onClose} className="mr-2">
          Cancelar
        </Button>
      </ModalFooter>
    </Modal>
  );
}

CrqModalComponent.propTypes = {
  isOpen: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  initialData: PropTypes.shape({
    id: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
    descricao: PropTypes.string,
    impacto: PropTypes.oneOf(['Total', 'Parcial']),
    numero: PropTypes.string,
    dataInicio: PropTypes.string,
    dataFim: PropTypes.string,
    status: PropTypes.oneOf([
      'Aprovada',
      'Cancelada',
      'Fechada',
      'Pedir',
      'Rejeitada',
      'Solicitada',
    ]),
    tipo: PropTypes.oneOf(['Impacto', 'Instalação', 'CRQ']),
  }),
};

export default CrqModalComponent;

export const salvarCrq = async (data, ididentificador, setCrqModalOpen, carregarTPs) => {
  try {
    const payload = {
      id: data?.id,
      siteId: `ERICSSON${ididentificador}`,
      descricao: data.descricao?.trim(),
      tipoRegistro: 'CRQ',
      impacto: data.impacto,
      numero: data.numeroCrq?.trim(),
      dataInicio: data.dataInicio ? `${data.dataInicio} 00:00:00` : null,
      dataFim: data.dataFim ? `${data.dataFim} 00:00:00` : null,
      status: data.status,
      tipo: data.tipo,
      empresa: 'ERICSSON',
    };

    await api.post('v1/acesso/tp', payload);
    setCrqModalOpen(false);
    await carregarTPs();
  } catch (err) {
    console.error(err);
  }
};
