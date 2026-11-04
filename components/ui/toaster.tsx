'use client';

import { useToast } from '@/components/ui/use-toast';
import {
  ToastProvider,
  ToastViewport,
  Toast,
  ToastClose,
  ToastDescription,
  ToastTitle,
} from '@/components/ui/toast';

export function Toaster() {
  const { toasts, dismiss } = useToast();

  return (
    <ToastProvider>
      {toasts.map(({ id, title, description, action, variant }) => (
        <Toast key={id} variant={variant}>
          <div className="grid gap-1">
            {title && <ToastTitle>{title}</ToastTitle>}
            {description && <ToastDescription>{description}</ToastDescription>}
          </div>
          {action}
          <ToastClose onClick={() => dismiss(Number(id))} />
        </Toast>
      ))}
      <ToastViewport />
    </ToastProvider>
  );
}
