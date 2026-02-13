import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Azure Sandbox",
  description: "Azure Sandbox Frontend",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ja">
      <body>{children}</body>
    </html>
  );
}
