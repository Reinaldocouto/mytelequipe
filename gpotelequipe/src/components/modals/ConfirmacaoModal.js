// ConfirmaModal.jsx
import PropTypes from 'prop-types';
import { useState } from 'react';

import {
  Dialog,
  DialogActions,
  DialogContent,
  DialogContentText,
  DialogTitle,
  Button,
} from '@mui/material';

export default function ConfirmaModal({ open, quantity, onConfirm, onCancel, campo }) {
  const labels = {
    statusobra: 'Status Obra',
    vistoriaplan: 'Vistoria Plan',
    vistoriareal: 'Vistoria Real',
    docplan: 'Documentação Vistoria Plan',
    docvitoriareal: 'Documentação Vistoria Real',
    req: 'REQ',
    entregaplan: 'Entrega Plan',
    entregareal: 'Entrega Real',
    fiminstalacaoplan: 'Fim Instalação Plan',
    fiminstalacaoreal: 'Fim Instalação Real',
    integracaoplan: 'Integração Plan',
    integracaoreal: 'Integração Real',
    ativacao: 'Ativação Real',
    documentacao: 'Documentação',
    datainventariodesinstalacao: 'Inventário Desinstalação',
    initialtunningreal: 'Initial Tunning Real Início',
    initialtunningrealfinal: 'Initial Tunning Real Final',
    initialtunnigstatus: 'Initial Tunning Status',
    aprovacaossv: 'Aprovação de SSV',
    statusaprovacaossv: 'Status Aprovação de SSV',
    dtplan: 'DT Plan',
    dtreal: 'DT Real',
    acompanhamentofisicoobservacao: 'Acompanhamento Físico Observação',
    rollout: 'Rollout',
    pmoaceitacaop: 'PMO Aceitação Plan',
    pmoaceitacaor: 'PMO Aceitação Real',
    acionamento: 'Acionamento',
  };
  const [disabledConfirmButton, setDisabledConfirmButton] = useState(false);

  const campoLabel = labels[campo] || campo;
  return (
    <Dialog open={open} onClose={onCancel}>
      <DialogTitle>Confirmar Alteração</DialogTitle>
      <DialogContent>
        <DialogContentText>
          Você deseja realmente alterar {quantity} {quantity > 1 ? 'campos' : 'campo'}{' '}
          <strong>{campoLabel}</strong>?
        </DialogContentText>
      </DialogContent>
      <DialogActions>
        <Button onClick={onCancel} color="error">
          Cancelar
        </Button>
        <Button
          disabled={disabledConfirmButton}
          onClick={async () => {
            try {
              setDisabledConfirmButton(true);
              await onConfirm();
            } finally {
              setDisabledConfirmButton(false);
            }
          }}
          variant="contained"
          color="primary"
        >
          Confirmar
        </Button>
      </DialogActions>
    </Dialog>
  );
}

ConfirmaModal.propTypes = {
  open: PropTypes.bool.isRequired,
  quantity: PropTypes.number.isRequired,
  onConfirm: PropTypes.func.isRequired,
  onCancel: PropTypes.func.isRequired,
  campo: PropTypes.string.isRequired,
};
