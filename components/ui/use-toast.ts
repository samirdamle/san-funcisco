'use client';

import { useCallback, useState } from 'react';
import { ToastActionElement, ToastProps } from '@radix-ui/react-toast';
import { ToastProvider, ToastViewport, Toast } from '@/components/ui/toast';
import { ToastTitle, ToastDescription, ToastClose, ToastAction } from '@/components/ui/toast';

type ToasterToast = {
  id: string;
  title?: React.ReactNode;
  description?: React.ReactNode;
  action?: ToastActionElement;
  variant?: 'default' | 'destructive' | 'success';
  promise?: Promise<any>;
};

let toastId = 0;
const toasts: ToasterToast[] = [];

function generateId() {
  return ++toastId;
}

function dismiss(id: number) {
  const index = toasts.findIndex(t => t.id === id);
  if (index !== -1) {
    toasts.splice(index, 1);
  }
}

function useToast() {
  const [toastList, setToastList] = useState<ToasterToast[]>([]);

  const toast = useCallback(
    ({ variant = 'default', ...props }: Omit<ToasterToast, 'id'>) => {
      const id = generateId();
      const newToast: ToasterToast = { id: id.toString(), variant, ...props };
      toasts.push(newToast);
      setToastList([...toasts]);
      return id;
    },
    []
  );

  const success = useCallback(
    (props: Omit<ToasterToast, 'id' | 'variant'>) => {
      return toast({ variant: 'success', ...props });
    },
    [toast]
  );

  const error = useCallback(
    (props: Omit<ToasterToast, 'id' | 'variant'>) => {
      return toast({ variant: 'destructive', ...props });
    },
    [toast]
  );

  return {
    toast,
    success,
    error,
    dismiss,
    toasts: toastList,
  };
}

export { useToast, type ToasterToast };
