import { createContext, useContext, type ReactNode } from "react";
import { useProgressStream, type ProgressEntry } from "../hooks/useProgressStream";

interface QueueStreamContextValue {
	progress: Record<number, ProgressEntry>;
	isConnected: boolean;
}

const QueueStreamContext = createContext<QueueStreamContextValue | null>(null);

/**
 * Provides a single shared SSE connection to /api/queue/stream for
 * all dashboard components. Without this, each component that calls
 * useProgressStream() independently would open its own connection.
 */
export function QueueStreamProvider({ children }: { children: ReactNode }) {
	const { progress, isConnected } = useProgressStream();

	return (
		<QueueStreamContext.Provider value={{ progress, isConnected }}>
			{children}
		</QueueStreamContext.Provider>
	);
}

export function useQueueStreamContext(): QueueStreamContextValue {
	const ctx = useContext(QueueStreamContext);
	if (!ctx) {
		throw new Error("useQueueStreamContext must be used inside <QueueStreamProvider>");
	}
	return ctx;
}
