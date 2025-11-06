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

export function CrqModalComponent({ isOpen, onClose, onSubmit, initialData }) {
  const [form, setForm] = useState({
    atividade: '',
    impacto: 'Total',
    numeroCrq: '',
    inicioCrq: '',
    finalCrq: '',
    status: 'Solicitada',
    tipoCrq: 'CRQ',
  });
  const formatDate = (value) => {
    if (!value) return '';
    return value.split(' ')[0]; // remove hora se vier do backend
  };
  useEffect(() => {
    if (initialData) {
      setForm((prev) => ({
        ...prev,
        atividade: initialData.atividade ?? prev.atividade,
        impacto: initialData.impacto ?? prev.impacto,
        numeroCrq: initialData.numeroCrq ?? prev.numeroCrq,
        inicioCrq: initialData.inicioCrq ?? prev.inicioCrq,
        finalCrq: initialData.finalCrq ?? prev.finalCrq,
        status: initialData.status ?? prev.status,
        tipoCrq: initialData.tipoCrq ?? prev.tipoCrq,
      }));
    }
  }, [initialData]);

  const impactoOptions = ['Total', 'Parcial'];
  const statusOptions = ['Aprovada', 'Cancelada', 'Fechada', 'Pedir', 'Rejeitada', 'Solicitada'];
  const tipoCrqOptions = ['Impacto', 'Instalação', 'CRQ'];

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
                <Label for="atividade">Atividade</Label>
                <Input
                  id="atividade"
                  name="atividade"
                  type="text"
                  value={form.atividade}
                  onChange={handleChange}
                  placeholder="Descreva a atividade"
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
                <Label for="inicioCrq">Início CRQ</Label>
                <Input
                  id="inicioCrq"
                  name="inicioCrq"
                  type="date"
                  value={formatDate(form.inicioCrq)}
                  onChange={handleChange}
                />
              </FormGroup>
            </div>
            <div className="col-md-3">
              <FormGroup>
                <Label for="finalCrq">Final CRQ</Label>
                <Input
                  id="finalCrq"
                  name="finalCrq"
                  type="date"
                  value={formatDate(form.finalCrq)}
                  onChange={handleChange}
                />
              </FormGroup>
            </div>
            <div className="col-md-3">
              <FormGroup>
                <Label for="status">Status</Label>
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
                <Label for="tipoCrq">Tipo CRQ</Label>
                <Input
                  id="tipoCrq"
                  name="tipoCrq"
                  type="select"
                  value={form.tipoCrq}
                  onChange={handleChange}
                >
                  {tipoCrqOptions.map((opt) => (
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
        <Button color="secondary" onClick={onClose} className="me-2">
          Cancelar
        </Button>
        <Button color="primary" onClick={handleSubmit}>
          Salvar CRQ
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
    atividade: PropTypes.string,
    impacto: PropTypes.oneOf(['Total', 'Parcial']),
    numeroCrq: PropTypes.string,
    inicioCrq: PropTypes.string,
    finalCrq: PropTypes.string,
    status: PropTypes.oneOf([
      'Aprovada',
      'Cancelada',
      'Fechada',
      'Pedir',
      'Rejeitada',
      'Solicitada',
    ]),
    tipoCrq: PropTypes.oneOf(['Impacto', 'Instalação', 'CRQ']),
  }),
};

export default CrqModalComponent;
