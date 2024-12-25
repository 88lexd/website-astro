// An endpoint to test the application health
import { readFile } from 'fs/promises';

export async function GET() {
  try {
    // Read the file containing the version
    const version = await readFile('/app/version.txt', 'utf8');

    // Return the response with the version included
    return new Response(
      JSON.stringify({
        status: '200',
        statusText: 'OK',
        version: version.trim(), // Ensure no trailing newlines or spaces
      }),
      { headers: { 'Content-Type': 'text/html' } }
    );
  } catch (error) {
    // Handle errors (e.g., file not found)
    const errorMessage =
      error instanceof Error ? error.message : 'Unknown error';

    return new Response(
      JSON.stringify({
        status: '500',
        statusText: 'Internal Server Error',
        error: errorMessage,
      }),
      { headers: { 'Content-Type': 'text/html' } }
    );
  }
}
