<?php

declare(strict_types=1);

namespace App\Message;

use Symfony\Component\Messenger\Attribute\AsMessage;

#[AsMessage('async')]
final class BatchSyncStartedMessage
{
    public function __construct(public readonly int $syncHistoryId)
    {
    }
}
