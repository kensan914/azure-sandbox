type ApiResponse = {
  message: string;
};

type HealthResponse = {
  status: string;
};

async function fetchApi<T>(path: string): Promise<T | null> {
  const baseUrl = process.env.API_BASE_URL || "http://localhost:8000";
  try {
    const res = await fetch(`${baseUrl}${path}`, {
      cache: "no-store",
    });
    return (await res.json()) as T;
  } catch {
    return null;
  }
}

export default async function Home() {
  const [apiData, healthData] = await Promise.all([
    fetchApi<ApiResponse>("/"),
    fetchApi<HealthResponse>("/health"),
  ]);

  return (
    <main style={{ fontFamily: "system-ui, sans-serif", padding: "2rem" }}>
      <h1>Azure Sandbox</h1>

      <section style={{ marginTop: "2rem" }}>
        <h2>GET /</h2>
        {apiData ? (
          <pre
            style={{
              background: "#f4f4f4",
              padding: "1rem",
              borderRadius: "4px",
            }}
          >
            {JSON.stringify(apiData, null, 2)}
          </pre>
        ) : (
          <p style={{ color: "red" }}>API に接続できませんでした</p>
        )}
      </section>

      <section style={{ marginTop: "2rem" }}>
        <h2>GET /health</h2>
        {healthData ? (
          <pre
            style={{
              background: "#f4f4f4",
              padding: "1rem",
              borderRadius: "4px",
            }}
          >
            {JSON.stringify(healthData, null, 2)}
          </pre>
        ) : (
          <p style={{ color: "red" }}>API に接続できませんでした</p>
        )}
      </section>
    </main>
  );
}
